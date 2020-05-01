+++
title = "Spinning the wheel"
slug = "2014-12-09-spinning-the-wheel"
published = 2014-12-09T19:56:00+01:00
author = "Jef Claes"
tags = [ "F#",]
+++
In this post, I'll define a basic set of data structures and functions
to spin a wheel of fortune. In the next post, I'll show you the simple
model casinos use to build a bigger, more attractive pot, without
touching the physical wheel and without losing money. Finally, I'll show
you how casinos tweak that model to bend the odds and create near
misses.  
  

[![](/post/images/thumbnails/2014-12-09-spinning-the-wheel-SpinTheWheel.png)](/post/images/2014-12-09-spinning-the-wheel-SpinTheWheel.png)

  
Let's say we have a physical wheel with four pockets, which are labeled
either miss or win.  
  

Three out of four pockets are labeled as a miss, one is labeled as a
win. This makes the odds to win one out of four, or 25%.  
  

Spinning the wheel, we should end up in one of four pockets. We can do
this by picking a random index of the physical wheel.  
  

To avoid a shoulder injury spinning the wheel multiple times, we'll
define a function that does this for us instead.  
  

Now I can spin the wheel one million times.  
  

If the math adds up, we should win 25% of the time. To verify this,
we'll group the results by label and print them.  
  

Give or take a few hundred spins, we're pretty close to winning 25% of
the time.  
  

When the odds are this fair, it's impossible to come up with an
attractive enough payout without the casino going broke. What if we
wanted to advertise a bigger pot, while keeping the same physical wheel,
without losing money? Tomorrow, I'll write about the simple model
casinos have been using to achieve this.
