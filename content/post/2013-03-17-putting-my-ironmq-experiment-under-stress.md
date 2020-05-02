+++
title = "Putting my IronMQ experiment under stress"
slug = "2013-03-17-putting-my-ironmq-experiment-under-stress"
published = 2013-03-17T16:10:00+01:00
author = "Jef Claes"
tags = [ "code", "infrastructure"]
url = "2013/03/putting-my-ironmq-experiment-under.html"
+++
Two weeks ago, [I shared my first impressions of
IronMQ](http://www.jefclaes.be/2013/03/first-ironmq-impressions.html).
Last week, [I looked at some infrastructure to facilitate pulling from
IronMQ](http://www.jefclaes.be/2013/03/some-experimental-infrastructure-for.html).
This implementation worked, but I hadn't put it under stress yet; "First
make it work, then make it fast", and all of that.  

I arranged a simple scenario for testing: one message type - thus one
queue, where there are eight queue consumers that simultaneously pull
messages from that queue, and dispatch them to a handler which sleeps
for one second.  

```csharp
public class MessageSleepForOneSecond { }

public class MessageSleepForOneSecondHandler : IMessageHandler<MessageSleepForOneSecond>
{
    public void Handle(MessageSleepForOneSecond message)
    {
        Thread.Sleep(1000);
    }
}
```

To establish a baseline, I foolishly set the polling interval to only
100ms, and pulled 2000 messages from the queue one at a time. With this
configuration I processed all 2000 messages in 2 minutes and 20 seconds,
with an average throughput of 14.3 messages per second. In theory you
would expect the throughput to be higher though.

The constraint in this story is the [CLR's thread
pool](http://msdn.microsoft.com/en-us/library/system.threading.threadpool.aspx).
Every time a queue consumer's internal timer ticks, the callback which
pulls from the queue and invokes the messagehandler, takes up a new
thread on the thread pool. The thread pool makes a few threads available
when you start your application, but once they're all in use, it will
have to start new ones, which is rather expensive. More importantly
though, when you're queuing too many tasks on the thread pool, and the
number of active threads is higher than the number of processors, it
will slow down, and wait 500ms to see if it can reuse the existing
threads, before creating a new one. When the maximum number of threads
is reached, the thread pool will still enlist your tasks in its queue,
but only start processing them once threads become available again. In
short, the thread pool has a few tricks up its sleeve to protect you
from saturating your resources. Remember that too much parallelization
and its corresponding context switches won't do you any good.  
  
Having established a baseline, and having learned a bit more on how the
thread pool behaves, I tried one of the first optimizations I already
had in mind last week; pulling batches instead of single messages. This
reduces the number of necessary HTTP requests, and the number of threads
needed to do work on. To support this, I extended the queue consumer
configuration with a new property, and changed the queue consumer to
take the batch size into account.  

```csharp
public interface IQueueConsumerConfiguration<T>
{
    int PollingInterval { get; }
    int BatchSize { get; }
}

try
{
    var messages = (IEnumerable<Message>)null;

    if (!_queue.TryGet(out messages, _queueConsumerConfiguration.BatchSize))
        return;

    foreach (var message in messages)
    {
        try
        {
            var messageBody = (T)JsonConvert.DeserializeObject(message.Body, typeof(T));

            _messageDispatcher.Dispatch<T>(messageBody);

            _queue.Delete(message.Id);
        }
        catch (Exception ex)
        {
            _errorHandler.Handle(ex, message);
        }
    }
}
catch (Exception ex)
{
    _errorHandler.Handle(ex, null);
}                
```

On repeating the test with 2000 messages, the same polling interval of
100ms, but with a batch size of 30, the messages were now all processed
in one minute and fifteen seconds, resulting in a throughput of 26
messages per second. That's almost an improvement of 100%.  
  
This throughput isn't sustainable though if we had a lot more messages
to process. We're starting a new thread every 100ms or 500ms, while the
work we are doing on it only finishes after a rough 30 seconds (it's not
only invoking the handlers, but the HTTP requests also take time). We're
burning through threads quicker than we're releasing them. If we would
run out of threads on the thread pool, it would just stop starting new
ones, and queue the tasks until other threads are done doing work.  
  
In my previous post I also considered a smart polling algorithm, but I
haven't looked at that yet, what's in place is more than good enough for
me at the moment.  
  
Be sure to take these numbers with a grain of salt. I would have to test
my infrastructure with millions of messages on the queue instead of just
2000 to get trustworthy results. I feel I can predict fairly well how
the system will behave when put under load for a longer amount of time
though; it would grind to a halt. As mentioned before, we would run out
of threads to do work on. I simulated this by lowering the thread pool's
maximum number of threads. Other parameters that influence the numbers
in this test are: size of the messages, version of the runtime, the
operating system, the amount of processors, latency of the network... I
ran these tests with empty messages, .NET 4 installed on my own Windows
7 box with an Intel i7 on board.  
  
It comes down to cherry picking a configuration per queue consumer that
will be sustainable based on the amount of messages you expect, the
desired throughput, and the time it takes to process a single message.