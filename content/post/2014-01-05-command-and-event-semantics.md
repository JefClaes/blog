+++
title = "Command and event semantics"
slug = "2014-01-05-command-and-event-semantics"
published = 2014-01-05T18:12:00+01:00
author = "Jef Claes"
tags = [ "code", "opinion"]
url = "2014/01/command-and-event-semantics.html"
+++
Yesterday, I read [this blog post by Michael
Feathers](https://michaelfeathers.silvrback.com/when-it-s-okay-for-a-method-to-do-nothing).
In the post he goes over a pain point he has often found himself
struggling with while breaking down a large method; conditional
statements. 

```csharp
if (alarmEnabled) {
    var alarm = new Alarm();  
    ...
    alarm.Sound();
}
```

Should we extract the if and the associated block into a new method, or
just the content of the block? Is the condition too important to hide in
a method? How would we name the extracted method? How do we avoid the
code from telling us lies?  
  
To read up on all the nuances that the answers to these questions bring,
you should read the full post. What's important for this post - spoiler
alert - is that he ends up with two strategies.  
  
He either gives the method an event-ish name...  

```csharp
IntruderDetected();
```

...or raises the level of abstraction by giving the method a very
general name, avoiding lies too.

```csharp
PerformNotifications();
```

While both options solve the original problem, their semantics are very
different. When I raise an event, I don't care who is listening; one,
multiple or no things might be listening. When I issue a command (the
second strategy), I expect it to go to exactly one destination. Sending
commands indicates a rather strong dependency; you expect something to
happen because of it. Events are more loosely coupled; you broadcast
something happened, and something might or might not happen because of
it.  
  
With this in mind, you can still make arguments for both options. The
key here is whether notifications are considered to be an essential
component of intrusion detection. Is intrusion detection still
conceptually whole without notifications? Are notifications just a side
effect of an intruder being detected?  
Since the alarm is only sounded when it's enabled, it doesn't seem to be
an indispensable part. Intrusion detection can live on its own, unaware
of notifications. This makes a pretty strong case for having the
detection component just raise an event - indirectly resulting in the
notifications being sent.  
  
In this example, I'd probably pull notifications out, add an event and a
bit of infrastructure that dispatches events, making the separate
concepts and messages between them explicit.

```csharp
Events.Raise(new IntruderDetected());

public class NotificationService : IHandle<IntruderDetected>
{
    public void Handle(IntruderDetected event)    { ... }        
}
```

With those extra bits, we could also, instead of listen for the event
and only sounding the alarm when it's enabled, only subscribe to the
event when the alarm is enabled.
