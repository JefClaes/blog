+++
title = "GES scavenging and the hidden cost of link events"
slug = "ges-scavenging-and-the-hidden-cost-of-link-events"
published = 2018-08-12T14:58:00.001000+02:00
author = "Jef Claes"
tags = [ "infrastructure",]
url = "2018/08/ges-scavenging-and-hidden-cost-of-link.html"
+++
Somewhere around a year ago, we started using
[GES](https://eventstore.org/) in production as the primary data store
of our new loyalty system. The system stores two types of data.  

1.  External services push batches of dumb downed events to the loyalty
    system. For example: a user logged on, played a game or participated
    in a competition. These events are **transient** by nature. Once the
    loyalty system has processed them, they only need to be kept around
    for a few days.
2.  When these ingress events are processed, they go through a mini
    pipeline in which each event is assigned a specific weight, for then
    to be aggregated and translated to a command. This command awards a
    user with virtual currency to spend in the loyalty shop and a number
    of points contributing to a higher rank - unlocking more priviliges.
    The state machine that stores a user's balance and points is backed
    by a stream which is **stored indefinitely**. Unless the user asks
    to be forgotten that is.

As a rough estimate, for every 1000 ingress transient events, only 1
needs to be stored indefinitely as part of a state machine.

When implementing this more than a year ago, I thought I had done my
homework and knew how to make sure the ingress events would get cleaned
up. First you make sure the *$maxAge* metadata is set on the streams you
want to clean up, for then to schedule the scavenging process (other
databases use the term vacuum). This worked without any surprises. Once
scavenging had been run, I could see disk space being released. However,
after a few months I started to become a bit suspicious of my
understanding of the scavening process. GES was releasing less disk
space than I expected.

Even though, we had been quite generous while provisioning the nodes
with disk space, we would run out very soon. Much to my frustration, the
"Storage is cheap" mantra gets thrown around too lightly. While the
statement in essence is not wrong, for a database like GES that's built
on top of a log, more data also means slower node restarts (index
verification), slower scavenges and slower *$all* subscriptions.

GES has no built-in system catalog that allows you to discover which
streams are taking up all this space. However, you can implement an $all
subscription and count events per stream or even count the bytes in the
event payload.

```csharp
static void Main(string[] args) {
    using (var conn = EventStoreConnection.Create(
        ConnectionSettings.Create().Build(),
        new IPEndPoint(IPAddress.Parse("127.0.0.1"), 1113))) {

        conn.ConnectAsync().Wait(5000);

        conn.SubscribeToAllFrom(
            Position.Start,
            CatchUpSubscriptionSettings.Default,
            eventAppeared: Count, liveProcessingStarted: Print, subscriptionDropped: Warn,
            userCredentials: new UserCredentials("admin", "changeit"));

        Console.ReadLine();
    }
}

private static void Print(EventStoreCatchUpSubscription sub) {
    foreach (var count in  counts.ToList().OrderByDescending(x => x.Value)) {
        Console.WriteLine($"{count.Key}: {count.Value}");
    }
}

private static Task Count(EventStoreCatchUpSubscription sub, ResolvedEvent e) {
    var ev = e.Link ?? e.Event;
    if (!counts.ContainsKey(ev.EventStreamId)) {
        counts.Add(ev.EventStreamId, 1);
    } else {
        counts[ev.EventStreamId] += 1;
    }

    return Task.CompletedTask;
}

// Output
// $et-LoggedIn : ...
// $et-GamePlayed : ...
// ...
```

Inspecting the results, we found that the streams emitted by the
built-in system projections contained a disproportionate amount of
events. Most of them were ingress events and should have been long
scavenged! As it turns out, this was a wrong assumption on my part.
Built-in projections build new streams by linking to the original event
(instead of a emitting a new one). But when an event is scavenged,
events linking to the original event still linger around on disk.
Although link events are much smaller than the original event usually -
it's just a pointer, the bytes used to store the pointer *and* the event
envelope still take up quite some space when there's billions of them!  
  
Luckily, I was only using a small portion of the built-in projections. I
created a custom projection that only created streams I was actually
interested in, pointed my code in the right direction, stopped the
built-in projections and deleted the now irrelevant streams.

Running the scavenging process after being able to delete all these
streams was very satisfying. The scavenging process loops through all
the transaction file chunks one by one. It reads a chunk and writes a
temporary new one, only containing the events that haven't been deleted.
Once it reaches the end of the file, it swaps out the newly written file
with the old one. Since writes are slower than reads, this makes that
scavenging is actually way faster when there's more to scavenge - or
less data to be written to a new file. After all the chunks have been
scavenged, the process merges the now smaller files into new chunks when
possible. This process is quite transparant by design; all you have to
do is list the files in the data directory when scavenging.  
  
When this whole process was complete, used disk space went down from
410GB to 47GB! Having trimmed all this excessive data, scavenging is
faster (hours not days), node restarts are faster and resetting an $all
subscription makes me less anxious.
