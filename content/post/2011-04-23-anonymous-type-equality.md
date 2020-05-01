+++
title = "Anonymous type equality"
slug = "2011-04-23-anonymous-type-equality"
published = 2011-04-23T15:15:00.001000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET",]
+++
Let's say you instantiate two variables (a and b) using [anonymous
types](http://msdn.microsoft.com/en-us/library/bb397696.aspx). They both
have the same two properties (x and y) with equal values.  
  

       1:  var a = new { x = 1, y = 2 };

       2:  var b = new { y = 2, x = 1 };

  
Do you think these two variables are equal?  
  

       1:  var areEquel = a.Equals(b);

       2:  Console.WriteLine(areEquel); //Prints false :O

  
These two variables are not equal. Not something I expected!  
  
If we look at the IL the C\# compiler produced, it starts making sense
though.  
  
[![](../images/thumbnails/2011-04-23-anonymous-type-equality-AnonymousTypeEquality.PNG)](../images/2011-04-23-anonymous-type-equality-AnonymousTypeEquality.PNG)  
There are two different types generated, although the properties we
assigned are the same. What differs is **the sequence of the property
assignment**.  
  
This is defined in chapter *7.6.10.6 Anonymous object creation
expressions* of the C\# 4.0 specifications.  

> Within the same program, two anonymous object initializers that
> specify a sequence of properties of the same names and compile-time
> types in the same order will produce instances of the same anonymous
> type.

  
**Conclusion**  
  
When defining anonymous types, the sequence of the property assignment
matters. If the sequence of the property assignment differs, different
types are defined by the C\# compiler.  
  
<span style="font-style:italic;">Also read [the
follow-up](http://jclaes.blogspot.com/2011/04/anonymous-type-equality-follow-up.html).</span>
