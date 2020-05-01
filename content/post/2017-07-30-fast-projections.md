+++
title = "Fast projections"
slug = "2017-07-30-fast-projections"
published = 2017-07-30T14:34:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets",]
+++
Most EventStore client libraries allow you to subscribe to a stream by
passing in a callback which is invoked when an event occurs (either a
live or historic event).

  

Let's say we subscribe to a stream of a popular video service, and we
want to project a read model that shows how many videos a viewer has
watched. We don't care about the bookmarked videos for now.

  

We're sitting on top of storage that can execute a single statement and
a batch of statements.  
  
The statements supported are limited:  

-   Set a checkpoint
-   Increment the view count for a viewer

  

The storage engine exposes a method which calculates the cost of
executed statements:  

-   Executing a single statement costs 1 execution unit
-   Executing a batch also costs 1 execution unit plus 0.1 execution
    unit per statement in the batch

**The stream**

**  
**

For this exercise the stream contains 3500 historic views, 50 historic
bookmarks and 100 live views.  
  

**First attempt**  
**  
**The first attempt at projecting the stream to state, executes a
statement for each event we're interested in and checkpoints after each
event (even the ones we're not interested in).  
  

The cost of this projection is high: 7250 execution units - even though
there are only 3600 events we're interested in. We execute a statement
for each event we handled and checkpoint immediately after, even for the
events we didn't handle.  
  
**Less checkpointing**  
**  
**It's not hard to get rid of some of the checkpointing though.

  

The cost has improved, but only marginally. We saved 50 execution units
by avoiding checkpointing after events we do not handle. Time for a
bigger improvement..  
  
**Batching**  
**  
**Instead of handling each event individually, we will buffer them as
soon as they come in. When we're catching up and seeing historic events,
we only flush the buffer every 100 events. When we're caught up, we
flush on each event. We want to always make a best attempt at showing
fresh data.  
  
When the buffer gets flushed, events are mapped into a sequence of
statements, which are sent in batch to the storage engine. The
checkpoint is appended to the tail of the batch.

  

This approach makes a significant difference. Execution cost has reduced
by 93%! Batching of historic events makes replays much faster, but with
some extra effort we can take this optimization even further.  
  
**Batching with transformation**  
**  
**It always pays off to understand the guarantees and intricacies of the
storage you're using. Looking closely at the storage interface, we find
that we can increment the view count by any number. If we use a local
data structure to aggregate the view count up front, we can reduce the
number of statements even further.  
  
In practice, we filter the for events we're interested in, group by the
viewer id, count the values and map that into a single statement per
viewer.

  

This further reduces costs by more than 2/3th. The optimization makes
the code a bit more elaborate, but not necessarily that more complex -
it's still a local optimization.  
  
**Conclusion**  
**  
**In three steps, we brought cost down from 7250 execution units to only
162 units. That makes me a 44x engineer, right?  
  
In general, storage is one of the slowest components of your system.
Making your system faster often involves making it do less work.
Avoiding waste by batching and some more work up front, can make a big
impact when you want to make your projection faster.  
  
You can find the complete F\# script
[here](https://gist.github.com/JefClaes/215d202fcdf9aa58968b92a129241292).