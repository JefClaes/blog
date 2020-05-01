+++
title = "When should you take performance into consideration?"
slug = "2011-11-27-when-should-you-take-performance-into-consideration"
published = 2011-11-27T17:55:00.001000+01:00
author = "Jef Claes"
tags = [ "Ramblings",]
+++
Before publishing [my previous post on rewriting an
if](http://jclaes.blogspot.com/2011/11/rewriting-if.html), I knew some
people would hate it, because the refactored construct is less
performant.  
  
Although I think performance is important, relevant performance
improvements are, apart from in tight loops, hardly ever to find in
language constructs. To put it more bluntly, they are a waste of time.
When translating your thoughts into code, you should aim to make your
intentions as clear as possible for the person who comes after you.
Don't obfuscate your code for an negligible performance improvement.  
  
I'm not advocating readability and pretty code are an end goal,
performance and quality still are. But look for optimizations where it
counts: optimizations which, after measuring, prove to be make a
significant impact on the overall performance of your system. These are
most likely to be found in I/O operations, architectures and algorithms.
Not in language constructs.
