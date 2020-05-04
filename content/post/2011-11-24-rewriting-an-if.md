+++
title = "Rewriting an if"
slug = "2011-11-24-rewriting-an-if"
published = 2011-11-24T21:12:00.001000+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2011/11/rewriting-if.html"
+++
Yesterday I came across an if statement that looked something like
this.  
  
```csharp
if (arg == "a" ||
    arg == "b" ||
    arg == "c" ||
    arg == "d" ||
    arg == "e") 
{
    Console.WriteLine(true);
}
```
  
An alternative way of writing this could look like this.  
  
```csharp
if (new [] { "a", "b", "c", "d", "e" }.Contains(arg))
    Console.WriteLine(true);
```
  
I can't remember in which Github repository I spotted this technique,
but I'm sure it was written in something other than C\#. I think it
works for C\# as well though. The language hardly gets in the way,
although it would be nice to be able to drop the new.  
  
This is one of these trivial things I tend to geek about. The condition
fits on one line now, making the eyes do less work. Also adding a
variable is less work; you don't have to enter and indent accordingly. I
think it's a win in readability, size and maintenance.  
  
But then I stop and wonder: how do you feel about this construct?
