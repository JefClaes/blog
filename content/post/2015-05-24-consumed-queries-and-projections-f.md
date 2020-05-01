+++
title = "Consumed: Queries and projections (F#)"
slug = "2015-05-24-consumed-queries-and-projections-f"
published = 2015-05-24T18:00:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "DDD", "F#",]
+++
This is the third post in my series on porting a node.js application to
an F\# application.  
  
So far, I've looked at [parsing command line
arguments](http://www.jefclaes.be/2015/04/parsing-command-line-arguments-with-f.html),
[handling commands and storing
events](http://www.jefclaes.be/2015/05/consumed-handling-commands-f.html).
Today, I want to project those events into something useful that can be
formatted and printed to the console.  
  
In the original application, I only had a single query. The result of
this query lists all items consumed grouped by category, sorted
chronologically  
  

Handling the query is done in a similar fashion to handling commands.
The handle function matches each query and has a dependency on the event
store.  
  
Where C\# requires a bit of plumbing to get declarative projections
going, F\#'s pattern matching and set of built-in functions give you
this for free.  
  
We can fold over the event stream, starting with an empty list, to
append each item that was consumed, excluding the ones that were removed
later. Those projected items can then be grouped by category, to be
mapped into a category type that contains a sorted list of items.  
  

The result can be printed to the console using a more imperative
style.  
  

And that's it, we've come full circle. We can now consume items, remove
items and query for a list of consumed items.  
  

Compared to the node.js implementation, the F\# version required
substantially less code (two to three times less). More importantly,
although I wrote tests for both, I felt way more confident completing
the F\# version. A strong type system, discriminated unions, pattern
matching, purity, composability and a smart compiler makes way for
sensible and predictable code.  
  
Source code is [up on Github](https://github.com/JefClaes/consumed-f).
