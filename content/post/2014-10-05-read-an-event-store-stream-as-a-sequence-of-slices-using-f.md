+++
title = "Read an Event Store stream as a sequence of slices using F#"
slug = "2014-10-05-read-an-event-store-stream-as-a-sequence-of-slices-using-f"
published = 2014-10-05T15:21:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET",]
+++
I'm slowly working on some ideas I've been playing around with whole
Summer. Since that's taking me to unknown territory, I guess I'll be
putting out more technical bits here in the next few weeks.

  

Using the [Event Store](http://geteventstore.com/), I tried to read all
events of a specific event type. This stream turned out to be a tad too
large to be sent over the wire in one piece, leading to a
PackageFramingException: Package size is out of bounds.  
  

The Event Store already has a concept of reading slices, allowing you to
read a range of events in the stream, avoiding sending too much over the
wire at once. This means that if you want to read all slices, you have
to read from the start, moving up one slice at a time, until you've
reached the end of the stream.  
  
Avoiding mutability, I ended up with a recursive function that returns a
sequence of slices.
