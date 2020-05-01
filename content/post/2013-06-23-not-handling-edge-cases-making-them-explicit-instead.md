+++
title = "Not handling edge cases, making them explicit instead"
slug = "2013-06-23-not-handling-edge-cases-making-them-explicit-instead"
published = 2013-06-23T16:49:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "DDD", "Ramblings",]
+++
When I wrote about [accidental
entities](http://www.jefclaes.be/2013/06/accidental-entities-what-about-ui.html)
earlier, we followed a consultant building software for a car rental
company. In the meanwhile, he has finished implementing the registration
of new cars. Next on the list is allowing customers to make a booking.  
  
We managed to get the CEO to set a whole hour apart to walk us over how
the booking system should work.  
  
**CEO**: "I'm not sure this meeting is going to take a whole hour
though. Making a booking is rather trivial. Do you have any idea on how
a booking would work?"  
**Us**: "Well, as far as I understand - and don't be too hard on me - a
customer makes a booking, we allocate the car for the requested period,
send the customer a confirmation email and we're done."  
**CEO**: "Hold your horses, it's not *that* trivial. When we receive a
booking, we first need to verify the customer's credit card."  
  
**Us**: "How do I verify a credit card?"  
**CEO**: "You don't. We use a third party electronic verification system
that does just that; they check if the credit card is valid and has
sufficient credit."  
  
**Us**: "What happens if the credit card is declined?"  
**CEO**: "That's easy; we just cancel the booking, and inform the
customer."  
  
**Us**: "And what happens when the credit card gets verified?"  
**CEO**: "Then we approve the booking."  
  
**Us**: "Let me stop you right there. Should we allocate the car
immediately as soon as the customer makes the booking?"  
**CEO**: "Hell no! Verification of the credit card can take a while; we
might lose business if the credit card turns out to get declined."  
  
**Us**: "Hmmm, what happens if someone else has made a booking for the
same car in the meanwhile?"  
**CEO**: "That's a good question. In the past, we've hardly encountered
this problem, but it does happen though; we should probably take care of
this edge case."  

  

**Us**: "How do you want to take care of these double bookings? I can
imagine you don't just want to cancel the second booking, and lose
business over this, right?"

**CEO**: "No, exactly; I like your thinking! There are a few options
here; if they only overlap for 30 minutes or so, we don't do anything.
When the customer comes to get his car, we apologize for the small delay
and offer him a frappuccino to soothe him. If the overlap is bigger, and
we have bigger or more expensive cars just sitting in the parking lot
for that period, we often give the customer a free upgrade. When we
don't have any expensive cars left, we let our best sales person call
the customer, and try to work something out. Sometimes we give them a
small discount, and they'll happily reschedule their plans a few hours
instead of having to look for another rental car. We try to avoid
canceling a booking as much as possible; we want to build a reputation
where we always deliver."

**Us**: "Wow, interesting. It's going to cost me some time to get that
right though. You said that this almost never happens. Since deciding on
a good solution for the double booking seems to be non-trivial, how
about we don't handle this edge case right now, but make it explicit
instead? We can mark the booking as double, make the system raise its
hand, and ask for human intervention. Backoffice users already have the
tools, and have the experience to decide on the best solution for the
double booking. Leaving this out for now would also make it possible to
go to market a few weeks earlier." 

**CEO**: "I really like this idea; let's keep our first version as lean
as possible. It really doesn't make much sense trying to automate this
right off the bat. It's not like you're cheap, you know. It would be
useful for the system to keep count of every double booking though. Can
we do that?"

**Us**: "Yep, that shouldn't be too hard."

  

After this talk with the CEO, we set out to model the solution in code. 

  

In our first iteration, a booking has multiple representations, a
representation for each state. One of the advantages of modeling it as
such, is that it allows us to make all possible state changes per
representation explicit; you can't accept a booking if the credit card
hasn't been approved etc... Alternatives could be the classic state
pattern, or something workflowish, but that isn't really the focus of
this post.

    var booking = new Booking(
        bookingId, carId,
        new Customer(new CreditCard("343705171682875"), new CustomerName("Jef", "Claes")), 
        new Period(DateTime.Now.AddDays(1), DateTime.Now.AddDays(4)));

    var bookingWithVerifiedCreditCard = booking.CreditcardVerified();
    var doubleBooking = bookingWithVerifiedCreditCard.Double();

Each state change triggers an event. If we output each event, and run
the snippet above we end up with this.

    (EVENT) BookingCreditCardVerificiationPending
    (EVENT) BookingCreditCardVerified
    (EVENT) DoubleBooked

The BookingCreditCardVerified event triggers us to detect doubles.

    public class BookingCreditCardVerifiedHandler : IHandle<BookingCreditCardVerified> 
    {    
        private readonly IBus _bus;

        public BookingCreditCardVerifiedHandler(IBus bus)
        {
            _bus = bus;
        }

        public void Handle(BookingCreditCardVerified @event)
        {
            _bus.Send(new DetectDoubleBooking(@event.BookingId));
        }
    }

If a double booking is detected, we want to make the system raise its
hand, and notify a human. This can be done through an email, a
notification in the backoffice portal, or whatever really.

    public class DoubleBookedHandler : IHandle<DoubleBooked>
    {
        public void Handle(DoubleBooked @event)
        {
            NotifyHumans();
        }

        private void NotifyHumans() { }
    }

Although, the technical implementation isn't very special, I think it
does show how events can help support the language and distribute
responsibility to where it belongs.  
  
There is this misconception that because we now have computers, they
should solve *all* our problems, even all the edge cases. Edge cases -
by definition - only happen at extreme conditions, and are regularly
hard to take care of in a satisfactory manner, without a considerable
investment. By making edge cases explicit, we allow a human to
intervene, and decide on the best solution for the problem. This way we
can go to market more quickly, with less code, and we might ironically
even end up with happier customers. By collecting statistics on how
often these edge cases occur, we can make a better informed decision on
whether it's worth the investment.
