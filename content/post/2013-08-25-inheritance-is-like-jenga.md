+++
title = "Inheritance is like Jenga"
slug = "2013-08-25-inheritance-is-like-jenga"
published = 2013-08-25T18:18:00+02:00
author = "Jef Claes"
tags = [ "opinion",]
url = "2013/08/inheritance-is-like-jenga.html"
+++
These last few days, I have been working on a piece of our codebase that
accidentally got very inheritance heavy.  
  
When it comes to inheritance versus composition, there are a few widely
accepted rules of thumb out there. While *prefer composition over
inheritance* doesn't cover the nuances, it's not terrible advice;
composition will statistically often be the better solution. Steve
McConnell's *composition defines a 'has a'- relationship while
inheritance defines an 'is a'-relationship*, gives you a more nuanced
and simple tool to apply to a scenario. The Liskov substitution
principle which states that, *if S is a subtype of T, then objects of T
may be replaced with objects of type S without any of the desirable
properties of that program*, is probably the most complete advice.  
  
Inheritance, when applied with the wrong motivations - reuse and such,
often leads to fragile monster class hierarchies which are too big to
wrap your head around and extremely hard to change.  
  
When I was working on such a monstrous hierarchy, it reminded me of
playing [Jenga](http://en.wikipedia.org/wiki/Jenga). Some time not that
long ago, someone had built this tower from the ground, laying block
over block, layer over layer. On the surface it appears to be stable and
rigid, but as soon as someone wants to winkle out one block, it becomes
obvious one block can bring down the whole structure. The lower the
block in the structure, the more layers rest on it, the greater the risk
of breaking everything on top. Even if you do succeed in pulling one
block out, chances are you had to touch the surrounding blocks to
prevent the tower from tumbling over.  
  
Instead of Jenga, I'd prefer a puzzle made of just a few pieces -
designed for toddlers. A puzzle is flat, you can see the big picture in
one glance, while you can reason about each piece individually as well.
As long as the edges of the pieces fit together, you can assemble
whatever picture you want.
