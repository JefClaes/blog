+++
title = "Visualizing event streams"
slug = "2015-12-20-visualizing-event-streams"
published = 2015-12-20T17:59:00+01:00
author = "Jef Claes"
tags = [ "DDD", "F#",]
+++
In my recent talk on [Evil by
Design](http://www.jefclaes.be/2015/11/slides-from-my-talk-evil-by-design-at.html),
I showed how I've been visualizing event streams as a means to get a
better grip on how aggregates behave in production. The talk's scope
kept me from showing the code that goes together with the examples
shown. Consider this post as an addendum to that talk.  
  
First off, we need a few types: a string that identifies a stream, an
event containing a timestamp and its name. A stream which is a
composition of an identifier and a sequence of events. We also need a
function that's able to read a stream based on its identifier.  
  

Once we've implemented that, we want to go ahead and visualize a single
stream. Having some experience with Google Charts, I used the
[XPlot.GoogleCharts](https://tahahachana.github.io/XPlot/) package.  
  
I want to visualize my event stream as a timeline. For that, it makes
only sense to use the Timeline graph. This means that I'll have to make
sure I transform my data into a format the Timeline chart can work with,
which is a sequence of tuples.

  

So we write a function which accepts a stream, and returns a sequence of
tuples containing the stream identifier, the event name and the
timestamp of the event.  
  

With just a few lines of code, we can already compose our way to a
timeline.

  

  
[![](../images/thumbnails/2015-12-20-visualizing-event-streams-eventstream_viz_1.PNG)](../images/2015-12-20-visualizing-event-streams-eventstream_viz_1.PNG)  
  
The result tells a small story: a withdrawal to a casino was requested
at 9:44PM, approved at 12:15PM the next day, and eventually completed 7
hours later.  
  
From an operational perspective, this visualization can be used as
visual assistance for your support team when users have a question or a
complaint. From a more technical perspective, it can be used to get a
feel of the domain language and business processes without having to
look at code or tests. I could even see this being used in the
front-end, where you enable users to monitor a process; think package
tracking, document verification and so on.  
  
Once you start exploring aggregates, you will notice that some
aggregates look healthier than others; lean and short-lived. While other
aggregates are fat and long-lived which can introduce a set of
problems:  
  

-   rebuilding state from a large event stream might kill performance
-   there's often more contention on larger aggregates making optimistic
    (or pessimistic) concurrency very annoying

  
[![](../images/thumbnails/2015-12-20-visualizing-event-streams-eventstream_vis_1_1.PNG)](../images/2015-12-20-visualizing-event-streams-eventstream_vis_1_1.PNG)  
  
Spotting one of these instances is an invitation to review your model,
to revise true invariants and to break things apart.  
  
We've now looked at an aggregate's event stream in isolation, but often
something happening in one place leads to a reaction somewhere else. A
simple example: when a new user registers, a promotion is awarded. We
can visualize this by rendering multiple streams on one timeline.  
  
Technically, we need to transform a sequence of streams to a single
sequence of tuples which we can feed the chart. It's as simple as
mapping each stream for then to flatten the result into a single
sequence.  
  

This one extra step makes the result even more useful.  
  
[![](../images/thumbnails/2015-12-20-visualizing-event-streams-eventstream_viz_2.PNG)](../images/2015-12-20-visualizing-event-streams-eventstream_viz_2.PNG)  
  
There's more potential though; consider showing the payload when
hovering over an event, adding commands in the mix, zooming out, zooming
in, filtering...  
  
If this is something you could see being useful to you or your
organization, let me know! Maybe I can port some bits and polish the
concept in the open.
