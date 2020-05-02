+++
title = "Alternatives to Udi's domain events"
slug = "2014-03-02-alternatives-to-udis-domain-events"
published = 2014-03-02T18:21:00+01:00
author = "Jef Claes"
tags = [ "code", "ddd"]
url = "2014/03/alternatives-to-udis-domain-events.html"
+++
Almost four years ago [Udi Dahan introduced an elegant
technique](http://www.udidahan.com/2009/06/14/domain-events-salvation/)
that allows you to have your domain model dispatch events without
injecting a dispatcher into the model - keeping your model focused on
the business at hand.  
  
This works by having a static DomainEvents class which dispatches raised
events.  
  
This customer aggregate raises an event when a customer moves to a new
address.  

```csharp
public class Customer
{
    private readonly string _id;
    private Address _address;
    private Name _name;

    public Customer(string id, Name name, Address address)
    {
        Guard.ForNullOrEmpty(id, "id");
        Guard.ForNull(name, "name");
        Guard.ForNull(address, "address");

        _id = id;
        _name = name;
        _address = address;
    }

    public void Move(Address newAddress)
    {
        Guard.ForNull(newAddress, "newAddress");

        _address = newAddress;

        DomainEvents.Raise(new CustomerMoved(_id));
    }
}
```

By having a dispatcher implementation that records the events instead of
dispatching them, we can test whether the aggregate raised the correct
domain event.

```csharp
var recordingDispatcher = new RecordingDispatcher();
DomainEvents.Dispatcher = recordingDispatcher;

var customer = new Customer(
    "customer/1",
    new Name("Jef", "Claes"),
    new Address("Main Street", "114B", "Antwerp", "2018"));
customer.Move(new Address("Baker Street", "89", "Antwerp", "2018"));

recordingDispatcher.Raised(new CustomerMoved("customer/1")); // true
```

While this worked out great for a good while, I bumped into difficulties
scoping my unit of work and such when I redid some of my infrastructure.
While there are ways to have your container address these issues,
getting rid of the static components is simpler throughout.    
  
A popular event sourcing pattern is to have your aggregate record
events. There is no reason why we couldn't apply the same pattern here.
Using this technique, we still avoid having to inject something into our
models, plus we get rid of that static DomainEvents component.
Reponsibility of dispatching the events is now delegated to an upper
layer.

```csharp
public class Customer : IRecordEvents
{
    private readonly EventRecorder _recorder = new EventRecorder();

    private readonly string _id;
    private Address _address;
    private Name _name;

    public Customer(string id, Name name, Address address)
    {
        Guard.ForNullOrEmpty(id, "id");
        Guard.ForNull(name, "name");
        Guard.ForNull(address, "address");

        _id = id;
        _name = name;
        _address = address;
    }

    public EventStream RecordedEvents() 
    {
        return _recorder.RecordedEvents();
    }

    public void Move(Address newAddress)
    {
        Guard.ForNull(newAddress, "newAddress");

        _address = newAddress;

        _recorder.Record(new CustomerMoved(_id));
    }
}

var customer = new Customer(
    "customer/1",
    new Name("Jef", "Claes"),
    new Address("Main Street", "114B", "Antwerp", "2018"));
customer.Move(new Address("Baker Street", "89", "Antwerp", "2018"));

customer.RecordedEvents().Contains(new CustomerMoved("customer/1")); // true
```

Another altnernative is to [return events from your
methods](http://www.jayway.com/2013/06/20/dont-publish-domain-events-return-them/).
This technique puts the responsibility of aggregating all events on to a
higher layer. Better to put that closer to the aggregate.  
  
What patterns are you using?
