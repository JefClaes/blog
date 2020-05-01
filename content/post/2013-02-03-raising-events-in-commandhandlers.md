+++
title = "Raising events in commandhandlers"
slug = "2013-02-03-raising-events-in-commandhandlers"
published = 2013-02-03T17:49:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "DDD",]
+++
I've explored quite a few options on how to handle commands and queries
in the last few posts. I finally settled on [this
approach](http://www.jefclaes.be/2013/01/separating-command-data-from-logic-and.html).
The example used in that post looked like this.  

    public class CreateSubscriptionCommandHandler : ICommandHandler<CreateSubscriptionCommand>
    {    
        private IDocumentSession _session;

        public CreateSubscriptionCommandHandler(IDocumentSession session)
        {
            _session = session;
        }

        public void Handle(CreateSubscriptionCommand command)
        {
            var subscription = new Documents.Subscription(
                command.Value, command.Category, command.EmailAddress);

            _session.Store(subscription);    
        }
    }

Now imagine I would want to do some extra stuff *after* creating the
subscription; update the sales statistics, append the email address to a
mailing list, send out a confirmation email, etc..  
  
You could go at this by simply extending the commandhandler, but the
problem here is that you quickly end up with a bulky and
dependency-heavy commandhandler, which will quickly fail to communicate
its intent.  
  
One solution could be to introduce events to decouple things in smaller
pieces, and to help communicate intent more clearly.  
  
The infrastructure to handle events is rather straightforward, and can
be based on [Udi Dahan's Domain Events
Salvation](http://www.udidahan.com/2009/06/14/domain-events-salvation/).  

    public class Events : IEvents
    {
        private readonly IKernel _kernel;

        public Events(IKernel kernel)
        {
            _kernel = kernel;
        }

        public void Raise<T>(T @event) where T : IEvent
        {
            var handlers = _kernel.GetAll<IEventHandler<T>>();

            foreach (var handler in handlers)        
                handler.Handle(@event);        
        }     
    }

When an event is raised, the eventing infrastructure will look in the
container for implementations that can handle the event, and invoke them
in a random order.  
  
Raising an event from the commandhandler can be done by injecting this
extra piece of infrastructure.  

    public class CreateSubscriptionCommandHandler : ICommandHandler<CreateSubscriptionCommand>
    {    
        private IDocumentSession _session;
        private readonly IEvents _events;

        public CreateSubscriptionCommandHandler(IDocumentSession session, IEvent events)
        {
            _session = session;
            _events = events;
        }

        public void Handle(CreateSubscriptionCommand command)
        {
            var subscription = new Documents.Subscription(
                command.Value, command.Category, command.EmailAddress);

            _session.Store(subscription);    
            
            _events.Raise(new SubscriptionCreatedEvent(query.Id));
        }
    }

The SubscriptionCreatedEvent class is a simple value object, which
exposes the subscription identifier.  

    public class SubscriptionCreatedEvent : IEvent
    {
        public SubscriptionCreatedEvent(string subscriptionId)
        {
            SubscriptionId = subscriptionId;
        }

        public string SubscriptionId { get; private set; }

        public override bool Equals(Object other)
        {
            if (other == null)
                return false;

            var otherEvent = other as SubscriptionCreatedEvent;
            if (otherEvent == null)
                return false;

            return otherEvent.SubscriptionId == SubscriptionId;
        }

        public override int GetHashCode()
        {
            return SubscriptionId.GetHashCode();
        }
    }   

To subscribe to this event, implement the IEventHandler interface, and
register the implemenation in the container.  

    public interface IEventHandler<T> where T : IEvent
    {
        void Handle(T @event);
    }

    public class SendConfirmationMailOnSubscriptionCreated : IEventHandler<SubscriptionCreatedEvent>
    {    
        public void  Handle(SubscriptionCreatedEvent @event)
        {
            ...
        }
    }

    public class UpdateSalesStatisticsOnSubscriptionCreated : IEventHandler<SubscriptionCreatedEvent>
    {    
        public void  Handle(SubscriptionCreatedEvent @event)
        {
            ...
        }
    }

Eventhandlers are invoked synchronously, and participate in the
commandhandler's unit of work, so if something goes haywire in one of
the eventhandlers, nothing gets committed, not even what happened in the
original commandhandler. Depending on your requirements, you might want
to handle this differently though.  
  
With this approach, tests also become more compact. Commandhandler tests
now only need to assert that the event gets raised, and all the other
logic gets offloaded to separate tests per eventhandler.  
  
**Summary**  
**  
**By introducing events, you can decouple commandhandlers into more
focused, and intent-revealing bits. Your tests are the perfect proof of
how much cleaner things get. One of the cues to listen for is *when* you
do x or *on* doing y, also do z.  
  
*Are you using events? If so, domain events, or its big brother Event
Sourcing?*
