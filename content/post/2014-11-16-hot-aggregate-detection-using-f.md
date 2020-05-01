+++
title = "Hot aggregate detection using F#"
slug = "2014-11-16-hot-aggregate-detection-using-f"
published = 2014-11-16T17:20:00+01:00
author = "Jef Claes"
tags = [ "code", "ddd",]
url = "2014/11/hot-aggregate-detection-using-f.html"
+++
Last week, I wrote about [splitting a hot
aggregate](http://www.jefclaes.be/2014/11/splitting-hot-aggregates.html).
Discovering that specific hot aggregate was easy; it would cause
transactional failures from time to time.  
  
Long-lived hot aggregates often are an indication of a missing concept
and an opportunity for teasing things apart. Last week, I took one
long-lived hot aggregate and pulled smaller short-lived hot aggregates
out, identifying two missing concepts.  
  
Hunting for more hot aggregates, I could visualize event streams and use
my eyes to detect bursts of activity, or I could have a little function
analyze the event streams for me.  
  
Looking at an event stream, we can identify a hot aggregate by having a
lot of events in a short window of time.  
  
[![](/post/images/thumbnails/2014-11-16-hot-aggregate-detection-using-f-HotAggregateDetection.png)](/post/images/2014-11-16-hot-aggregate-detection-using-f-HotAggregateDetection.png)

Let's say that when six events occur within five seconds from each
other, we're dealing with a hot aggregate.  

```fsharp
[<Test>]
member this.``Given a hot aggregate, a hot aggregate will be detected``() = 
	let treshold = 4
	let secondsInWindow = 5		   
	let eventStream = createEventStream [0; 1; 2; 10; 11; 12; 13; 14; 60; 90]
	   
	streamIsHot eventStream treshold secondsInWindow |> should equal true
```

What I came up with is a function that folds over an event stream. It
will walk over each event, maintaining the time window, allowing us to
look back in time. When the window size exceeds the treshold, the event
stream will be identified as hot. Once identified, the remaining events
won't be analyzed.

```fsharp
let streamIsHot (events : seq<Event>) treshold secondsInWindow =      
	let folder acc e =         
		let detect acc e = 
			let windowFilter = (fun x -> x >= e.Timestamp.AddSeconds(- float secondsInWindow))
			let window = e.Timestamp :: acc.Window |> List.filter windowFilter
			let hot = (window |> Seq.length) > treshold
			{ acc with Hot = hot; Window = window }

		match acc.Hot with 
			| true -> acc
			| false -> detect acc e   
			
	(Seq.fold folder initialDetectionResult events).Hot
```