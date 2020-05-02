+++
title = "Eventual consistent domain events with RavenDB and IronMQ"
slug = "2013-08-15-eventual-consistent-domain-events-with-ravendb-and-ironmq"
published = 2013-08-15T14:03:00+02:00
author = "Jef Claes"
tags = [ "code", "ddd", "infrastructure" ]
url = "2013/08/eventual-consistent-domain-events-with.html"
+++
Working on side projects, I often find myself using
[RavenDB](http://ravendb.net/) for storage and
[IronMQ](http://www.iron.io/mq) for queueing. I wrote about that last
one before
[here](http://www.jefclaes.be/2013/03/first-ironmq-impressions.html) and
[here](http://www.jefclaes.be/2013/03/putting-my-ironmq-experiment-under.html).  
  
One project I'm working on right now makes use of domain events. As an
example, I'll use the usual suspect: the `BookingConfirmed` event. When a
booking has been confirmed, I want to notify my customer by sending him
an email.  

I want to avoid that persisting a booking fails because an eventhandler
throws - the mail server is unavailable. I also don't want that an
eventhandler executes an operation that can't be rolled back - sending
out an email - without first making sure the booking was persisted
succesfully. If an eventhandler fails, I want to give it the opportunity
to fix what's wrong and retry.

```csharp
public void Confirm()
{
    Status = BookingStatus.Accepted;

    Events.Raise(new BookingConfirmed(Id));
}
```

### Get in line  

The idea is, instead of dealing with the domain events in memory, to
push them out to a queue so that  eventhandlers can deal with them
asynchronously. If we're trusting IronMQ with our queues, we get in
trouble guaranteeing that the events aren't sent out unless the booking
is persisted succesfully; you can't make IronMQ enlist in a
transaction.  
  
### Avoiding false events
  
To avoid pushing out events, and alerting our customer, without having
succesfully persisted the booking, I want to commit my events in the
same transaction. Since IronMQ can't be enlisted in a transaction, we
have to take a detour; instead of publishing the event directly, we're
going to persist it as a RavenDB document. This guarantees the event is
committed in the same transaction as the booking.

```csharp
public class DomainEvent
{
    public DomainEvent(object body)
    {
        Guard.ForNull(body, "body");          
        
        Type = body.GetType();
        Body = body;
        Published = false;
        TimeStamp = DateTimeProvider.Now();
    }
    
    protected DomainEvent() { }

    public string Id { get; private set; }

    public DateTime TimeStamp { get; private set; }

    public Type Type { get; private set; }

    public object Body { get; private set; }

    public bool Published { get; private set; }

    public void MarkAsPublished()
    {
        Published = true;
    }
}

public class DomainEvents : IDomainEvents
{
    private IDocumentSession _session;

    public DomainEvents(IDocumentSession session)
    {
        _session = session;
    }

    public void Raise<T>(T args) where T : IDomainEvent
    {       
        _session.Store(new DomainEvent(args));
    }
}
```

[![](/post/images/thumbnails/2013-08-15-eventual-consistent-domain-events-with-ravendb-and-ironmq-RavenDBDomainEvents.PNG)](/post/images/2013-08-15-eventual-consistent-domain-events-with-ravendb-and-ironmq-RavenDBDomainEvents.PNG)

### Getting the events out
  
Now we still need to get the events out of RavenDB. Looking into this,
I found this to be a very good use of the [Changes
API](http://ayende.com/blog/157121/awesome-feature-of-the-day-ravendb-changes-api).
Using the Changes API, you can subscribe to all changes made to a
certain document. If you're familiar with relation databases, the
Changes API might remind you of triggers - except for that the Changes
API doesn't live in the database, nor does it run in the same
transaction. In this scenario, I use it to listen for changes to the
domain events collection. On every change, I'll load the document, push
the content out to IronMQ, and mark it as published.

```csharp
public class DomainEventPublisher
{
    private readonly IQueueFactory _queueFactory;
    
    public DomainEventPublisher(IQueueFactory queueFactory)
    {           
        _queueFactory = queueFactory;
    }

    public void Start()
    {
        DocumentStore
            .Get()
            .Changes()
            .ForDocumentsStartingWith(typeof(DomainEvent).Name)
            .Subscribe(PublishDomainEvent);
    }

    private void PublishDomainEvent(DocumentChangeNotification change)
    {
        Task.Factory.StartNew(() =>
        {
            if (change.Type != DocumentChangeTypes.Put)
                return;

            using (var session = DocumentStore.Get().OpenSession())
            {
                var domainEvent = session.Load<DomainEvent>(change.Id);

                if (domainEvent.Published)
                    return;

                var queue = _queueFactory.CreateQueue(domainEvent.Type.Name);
                queue.Push(JsonConvert.SerializeObject(domainEvent.Body));

                domainEvent.MarkAsPublished();

                session.SaveChanges();
            }
        });
    }
}
```

I tested this by raising 10,000 events on my machine, and got up to an
average of pushing out 7 events a second. With an average of 250ms per
request, the major culprit is posting messages to IronMQ. Since I'm
posting these messages over the Atlantic, IronMQ is not really to blame.
Once you get closer, response times go down to the 10ms - 100ms range.  
  
### A back-up plan  

If the subscriber goes down, events won't be pushed out, so you need
to have a back-up plan. I planned for missing events by scheduling a
Quartz job that periodically queries for old unpublished domain events
and publishes them.  
  
### In conclusion  

You don't need expensive infrastructure or a framework to enable
handling domain events in an eventual consistent fashion. Using RavenDB
as an event store, the Changes API as an event listener, and IronMQ for
queuing, we landed a rather light-weight solution. It won't scale
endlessly, but it doesn't have to either.  
  
I'm interested in hearing which homegrown solutions you have come up
with, or how I could improve mine.