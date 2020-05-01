+++
title = "Print out the maximum depth of recursion allowed"
slug = "2014-10-19-print-out-the-maximum-depth-of-recursion-allowed"
published = 2014-10-19T17:33:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "C#", "F#",]
+++
[Karl Seguin](https://twitter.com/karlseguin) tweeted the following
earlier this week: "An interview question I sometimes ask: Write code
that prints out the maximum depth of recursion allowed."  
  
This question is interesting for a couple of reasons. First, it's a
shorter
[FizzBuzz](http://blog.codinghorror.com/why-cant-programmers-program/);
can the candidate open an IDE, write a few lines of code, compile and
run them? And second, does he know what recursion is?  
  
Now let's say, the interviewee knows how to write code and is familiar
with the concept of recursion. If he had to do this exercise in C\#, he
might come up with something along these lines.  
  

Before you let him run his code, you ask him to guess the output of this
little program. If he's smart, he won't give you much of an answer.
Instead he will point out that the result depends on the runtime,
compiler, compiler switches, machine architecture, the amount of
available memory and what not.  
  
If he's not familiar with the C\# compiler and runtime, he might even
say there's a chance the integer will overflow before the call stack
does.  
The recursive method call is the last call in this method, making it
tail-recursive. A smart compiler might detect the tail-recursion and
convert the recursive call into a plain loop, avoiding recursion.  
  
Running this program shows that the C\# compiler isn't that smart, and
will yield the maximum depth of recursion just before crashing.  
  

If we were to port this snippet to F\#, a functional language in which
recursion is a first class citizen, the results are a bit different.  
  

This just kept running until I killed it when the count was far over
171427. Looking at the generated IL, you can see that the compiler was
smart enough to turn this recursive function into a loop.  
  
If we want the F\# implementation to behave more like the C\# one, we
need to make sure the compiler doesn't optimize for tail recursion.  
  

Running this also ends in a StackOverflowException pretty early on.  
  
I love how this question seems shallow at the surface, but gives away
more and more depth the harder you look.
