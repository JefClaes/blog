+++
title = "Read an Event Store stream as a sequence of slices using F#"
slug = "2014-10-05-read-an-event-store-stream-as-a-sequence-of-slices-using-f"
published = 2014-10-05T15:21:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2014/10/read-event-store-stream-as-sequence-of.html"
+++
I'm slowly working on some ideas I've been playing around with whole
Summer. Since that's taking me to unknown territory, I guess I'll be
putting out more technical bits here in the next few weeks.

Using the [Event Store](http://geteventstore.com/), I tried to read all
events of a specific event type. This stream turned out to be a tad too
large to be sent over the wire in one piece, leading to a
`PackageFramingException: Package size is out of bounds`.  
  
```
[07,09:57:30.489,ERROR] TcpPackageConnection: [127.0.0.1:1113, L127.0.0.1:55697, {d9265236-f72b-4418-a470-780ab7ef2af9}]. Invalid TCP frame received.
EXCEPTION(S) OCCURRED:
EventStore.ClientAPI.Transport.Tcp.PackageFramingException: Package size is out of bounds: 186992564 (max: 67108864). 
   at EventStore.ClientAPI.Transport.Tcp.LengthPrefixMessageFramer.Parse(ArraySegment`1 bytes)
   at EventStore.ClientAPI.Transport.Tcp.LengthPrefixMessageFramer.UnFrameData(IEnumerable`1 data)
   at EventStore.ClientAPI.Transport.Tcp.TcpPackageConnection.OnRawDataReceived(ITcpConnection connection, IEnumerable`1 data)
```

The Event Store already has a concept of reading slices, allowing you to
read a range of events in the stream, avoiding sending too much over the
wire at once. This means that if you want to read all slices, you have
to read from the start, moving up one slice at a time, until you've
reached the end of the stream.  
  
Avoiding mutability, I ended up with a recursive function that returns a
sequence of slices.

```fsharp
let rec read stream startFrom (conn : IEventStoreConnection) = 
    seq {
        let size = 10000
        let slice = conn.ReadStreamEventsForwardAsync(stream, startFrom, size, true).Result

        if (slice.IsEndOfStream) then
           yield slice
        else
           yield slice
           yield! read stream (startFrom + size) conn 
    }

let slices = read "$et-event-name" 0 conn
```