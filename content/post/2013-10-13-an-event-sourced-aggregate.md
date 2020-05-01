+++
title = "An event sourced aggregate"
slug = "2013-10-13-an-event-sourced-aggregate"
published = 2013-10-13T18:36:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "Architecture", "DDD",]
+++
Last week I shared [my theoretical understanding of event
sourcing](http://www.jefclaes.be/2013/10/my-understanding-of-event-sourcing.html).
Today, I want to make an attempt at making that theory tangible by
implementing an event sourced aggregate.  
  
In traditional systems, we only persist the current state of an
object.  
  

[![](/post/images/thumbnails/2013-10-13-an-event-sourced-aggregate-TraditionalStorage.PNG)](/post/images/2013-10-13-an-event-sourced-aggregate-TraditionalStorage.PNG)

  
In event sourced systems, we don't persist the current state of an
object, but **the sequence of events that caused the object to be in the
current state**.  
  

[![](/post/images/thumbnails/2013-10-13-an-event-sourced-aggregate-EventSourcingStorage.PNG)](/post/images/2013-10-13-an-event-sourced-aggregate-EventSourcingStorage.PNG)

  

If we want an aggregate to be event sourced, it should be able to
rebuild itself from a stream of events, and it should be able to record
all the events it raises.

    public interface IEventSourcedAggregate : IAggregate
    {
        void Initialize(EventStream eventStream);

        EventStream RecordedEvents();
    }

Let's implement the example aggregate we used last week: an account. An
account owner can deposit and withdraw an amount from his account. There
is a maximum amount policy for withdrawals though.

    public class Account : IEventSourcedAggregate {
        private readonly Guid _id;

        public Account(Guid id) {
            _id = id;
        }

        public Guid Id { get { return _id; } }

        public void Initialize(EventStream eventStream) { 
            throw new NotImplementedException();
        }

        public EventStream RecordedEvents() { 
            throw new NotImplementedException(); 
        }
        
        public void Deposit(Amount amount) { }
        
        public void Withdraw(Amount amount) { }
    }

Next to the Initialize and RecordedEvents method, our aggregate facade
hasn't changed. We still have a Deposit and a Withdraw operation like we
would have in a traditional aggregate. How those two methods get
implemented differs though.  
  
When we deposit or withdraw an amount, we want to - instead of changing
the state directly - apply events. When an event gets applied its
handler will first be invoked, for the event then to be recorded.

    public void Deposit(Amount amount) {
        Apply(new AmountDeposited(amount));
    }

    public void Withdraw(Amount amount) {
        if (amount.IsOver(AmountPolicy.Maximum))     {
            Apply(new WithdrawalAmountExceeded(amount));

            return;
        }

        Apply(new AmountWithdrawn(amount));
    }

    private void Apply(IEvent @event) {
        When((dynamic)@event);
        _eventRecorder.Record(@event);
    }

An event recorder is a small object that keeps track of recorded events.

    public class EventRecorder
    {
        private readonly List<IEvent> _events = new List<IEvent>();

        public void Record(IEvent @event) {
            _events.Add(@event);
        }

        public EventStream RecordedEvents() {
            return new EventStream(_events);
        }
    }

This object will be used to have our aggregate return a stream of
recorded events.

    public EventStream RecordedEvents() {
        return _eventRecorder.RecordedEvents();
    }

We can now also implement initializing the aggregate from a stream of
events.

    public void Initialize(EventStream eventStream) {
        foreach (var @event in eventStream)
            When((dynamic)@event);
    }

Here too, event handlers are invoked by using the dynamic run-time to
find the best overload.  
  
It's the event handlers that will change the aggregate's state. In this
example, they can be implemented like this.

    private void When(AmountWithdrawn @event) {
        _amount = _amount.Substract(@event.Amount);
    }

    private void When(AmountDeposited @event) {
        _amount = _amount.Add(@event.Amount);
    }

    private void When(WithdrawalAmountExceeded @event) { }

A test verifies that when I invoke operations on the aggregate, all the
events are recorded, and the state has changed. When I use those
recorded events to rebuild the same aggregate, we end up with the same
state.

    [TestMethod]
    public void ICanReplayTheEventsAndHaveTheStateRebuilt() {
        var account = new Account(Guid.NewGuid());

        account.Deposit(new Amount(2500));
        account.Withdraw(new Amount(100));
        account.Withdraw(new Amount(200));

        Assert.AreEqual(3, account.RecordedEvents().Count());
        Assert.AreEqual(new Amount(2200), account.Amount);

        var events = account.RecordedEvents();

        var secondAccount = new Account(Guid.NewGuid());
        secondAccount.Initialize(events);

        Assert.AreEqual(new Amount(2200), secondAccount.Amount);
        Assert.AreEqual(0, secondAccount.RecordedEvents().Count());
    }

And this is all there is to an event sourced aggregate.  
  
For this exercise I tried to keep the number of concepts low. Many will
have noticed that extracting a few concepts would benefit re-use and
explicitness.  
  
Also using the DLR to invoke the correct event handlers might be frowned
upon; it's not the most performant method, each event must have a
handler, and in case a handler is missing the exception is not pretty.
Experienced readers will also have noticed concepts such as versioning
and snapshots are not implemented yet. I hope limiting the amount of
concepts and indirections made this blog post easier to read.  
  
*Any thoughts on this implementation?*  
*  
Next week: where do I persist these events?*
