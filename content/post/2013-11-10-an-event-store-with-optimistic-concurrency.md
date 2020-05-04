+++
title = "An event store with optimistic concurrency"
slug = "2013-11-10-an-event-store-with-optimistic-concurrency"
published = 2013-11-10T18:25:00.001000+01:00
author = "Jef Claes"
tags = [ "code", "infrastructure"]
url = "2013/11/an-event-store-with-optimistic.html"
+++
Like I mentioned [last
week](http://www.jefclaes.be/2013/11/event-source-all-things.html) -
after only five posts on the subject - there still are a great deal of
event sourcing nuances left to be discovered.  
  
[My current event store
implementation](http://www.jefclaes.be/2013/10/an-event-store.html) only
supports a single user. Due to an aggressive file lock, concurrently
accessing an aggregate will throw an exception. Can we allow multiple
users to write to and read from an event stream? Also, what can we do
about users making changes to the same aggregate; can we somehow detect
conflicts and avoid changes to be committed?  
  
## Multi-user
  
In the current version, concurrently appending to or reading from an
aggregate's event stream will throw since the file will already be
locked.

```csharp
Parallel.For(0, 1000, (i) =>
{    
    _eventStore.CreateOrAppend(aggregateId, new EventStream(new List<IEvent>() 
    { 
        new ConcurrencyTestEvent() 
    }));
    _eventStore.GetStream(aggregateId);    
});
```

The exception looks like this: `"System.IO.IOException: The process
cannot access the file
'C:\\EventStore\\92f42a08-8583-4dcf-98a5-440b06f34719.txt' because it is
being used by another process."` 
  
To prevent concurrent file access, we can lock code accessing the
aggregate's event stream. Instead of using a global lock, we maintain a
dictionary of lock objects; one lock object per aggregate.

```csharp
lock (Lock.For(aggregateId))
{
    using (var stream = new FileStream(
        path, FileMode.Append, FileAccess.Write, FileShare.Read))
    {
        // Access the aggregate's event stream
    }
}

public class Lock
{
    private static ConcurrentDictionary<Guid, object> _locks = 
        new ConcurrentDictionary<Guid, object>();

    public static object For(Guid aggregateId)
    {
        var aggregateLock = _locks.GetOrAdd(aggregateId, new object());

        return aggregateLock;
    }
}     
```

### Optimistic concurrency
 
Before committing changes, we want to verify that no other changes
have been committed in the meanwhile. These changes could have
influenced the behaviour of our aggregate significantly. Appending the
last changes without considering what might have happened in the
meanwhile might corrupt our aggregate's state.  
  
One way to verify this is by using a number (or a timestamp - clocks,
bah) to keep track of an aggregate's version. It's up to the client to
tell us which version he expects when appending to a stream. To
accommodate for this, we need to change the contract of our event store.

```csharp
public interface IEventStore
{
    void Create(Guid aggregateId, EventStream eventStream);

    void Append(Guid aggregateId, EventStream eventStream, int expectedVersion);

    ReadEventStream GetStream(Guid aggregateId);
}
```

Clients now need to pass in the expected version when appending to a
stream. The result of reading a stream will include the current
version.  
  
In the event store, we now store an index with every event.  
  
[![](/post/images/thumbnails/2013-11-10-an-event-store-with-optimistic-concurrency-EventsWithIndex.PNG)](/post/images/2013-11-10-an-event-store-with-optimistic-concurrency-EventsWithIndex.PNG)

If we append to an event stream, we will get the current version by
reading the highest index - storing this in aggregate meta data would be
faster for reading. If the current version doesn't match the expected
version, we throw an exception.  

```csharp
var currentVersion = GetCurrentVersion(path);

if (currentVersion != expectedVersion)
    throw new OptimisticConcurrencyException(expectedVersion, currentVersion);

using (var stream = new FileStream(
    path, FileMode.Append, FileAccess.Write, FileShare.Read))
{
    using (var streamWriter = new StreamWriter(stream))
    {
        foreach (var @event in eventStream)
        {
            currentVersion++;

            streamWriter.WriteLine(new Record(
                aggregateId, @event, currentVersion).Serialized());
        }
    }
}
```

A test for that looks something like this.

```csharp
try
{
    GivenEventStore();
    GivenAggregateId();
    GivenEventStreamCreated();
    WhenAppendingTwoEventStreamsWithTheSameExpectedVersion();
}
catch (OptimisticConcurrencyException ocex) 
{
    _expectedConcurrencyException = ocex;
}

[TestMethod]
public void ThenTheConcurrencyExceptionHasANiceMessage()
{
    var expected = "Version found: 3, expected: 1";
    var actual = _expectedConcurrencyException.Message

    Assert.AreEqual(expected, actual);
}
```

Reading the event stream doesn't change much; we now also read the
current version, and return it with the event stream. 

```csharp
var lines = File.ReadAllLines(path);

if (lines.Any())
{
    var records = lines.Select(x => Record.Deserialize(x, _assembly));
    var currentVersion = records.Max(x => x.Version);
    var events = records.Select(x => x.Event).ToList();

    return new ReadEventStream(events, currentVersion);
}

return null; 
```

And that's one way to implement optimistic concurrency. The biggest
bottleneck in this approach is how we read the current version; having
to read all the events to find the current version isn't very
efficient.  
  
Transactional behaviour is also missing. I've been thinking about adding
a `COMMIT` flag after appending a set of events, and using that to resolve
corruption on reads, or is this fundamentally flawed?
