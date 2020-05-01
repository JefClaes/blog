+++
title = "Functional one-liner for running totals in C#"
slug = "2016-03-28-functional-one-liner-for-running-totals-in-c"
published = 2016-03-28T16:22:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "C#", "F#",]
+++
Visualizing some data earlier this week I had to compute the [running
total](https://en.wikipedia.org/wiki/Running_total) of a sequence of
numbers.  
  
For example, if the input sequence was \[ 100; 50; 25 \] the result of
the computation would be a new sequence of \[ 100; 150; 175 \].  
  
Muscle memory made me take a procedural approach, which works, but made
me wonder if I could get away with less lines of code and without
mutable state.  
  

Although C\# doesn't try very hard to push a functional approach, the
BCL does give you some useful tools.  
  
The first thing that comes to mind is using [IEnumerable's Aggregate
function](https://msdn.microsoft.com/en-us/library/bb548651(v=vs.100).aspx),
which will apply a function over each item in the sequence and will pass
the aggregated partial result the next time the function is applied.
Each time the function is applied, we can take the last item (if it
exists) of the aggregated partial result and add the current item's
value to it, and append that sum to the aggregated partial result.

  

Another more compact - but less efficient approach - I could think of,
is using the index of each element in the sequence, to take subsets and
to sum their values.

  

Running out of ideas, I ported [F\#'s
Scan](https://msdn.microsoft.com/en-us/library/ee340364.aspx) function
which allows more compact code, without giving up efficiency. This
function, similar to the Aggregate function, applies a function over
each item in the sequence. However, instead of passing the aggregated
partial result each time the function is applied, the value of the last
computation is passed in, to finally return the list of all
computations.  
  

With a bit of good will, C\# allows you to be more functional too.
