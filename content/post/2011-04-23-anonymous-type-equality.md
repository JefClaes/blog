+++
title = "Anonymous type equality"
slug = "2011-04-23-anonymous-type-equality"
published = 2011-04-23T15:15:00.001000+02:00
author = "Jef Claes"
tags = [ "code",]
+++
Let's say you instantiate two variables (a and b) using [anonymous
types](http://msdn.microsoft.com/en-us/library/bb397696.aspx). They both
have the same two properties (x and y) with equal values.  
  
```csharp
var a = new { x = 1, y = 2 };
var b = new { y = 2, x = 1 };
```

Do you think they are equal?  
  
```csharp
Console.WriteLine(a.Equals(b)); //Prints false :O
```
  
They are not. Not something I expected!  
  
If we look at the IL the C\# compiler produced, it starts making sense
though.  
  
[![](/post/images/thumbnails/2011-04-23-anonymous-type-equality-AnonymousTypeEquality.PNG)](/post/images/2011-04-23-anonymous-type-equality-AnonymousTypeEquality.PNG)  
There are two different types generated, although the properties we
assigned are the same. What differs is **the sequence of the property
assignment**.  
  
This is defined in chapter *7.6.10.6 Anonymous object creation
expressions* of the C\# 4.0 specifications.  

> Within the same program, two anonymous object initializers that
> specify a sequence of properties of the same names and compile-time
> types in the same order will produce instances of the same anonymous
> type.

### Conclusion  
  
When defining anonymous types, the sequence of the property assignment
matters. If the sequence of the property assignment differs, different
types are defined by the C\# compiler.  
  
Also read [the
follow-up](https://www.jefclaes.be/2011/04/anonymous-type-equality-follow-up.html).
