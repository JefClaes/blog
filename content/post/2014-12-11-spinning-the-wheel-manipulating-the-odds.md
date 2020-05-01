+++
title = "Spinning the wheel: manipulating the odds"
slug = "2014-12-11-spinning-the-wheel-manipulating-the-odds"
published = 2014-12-11T19:24:00+01:00
author = "Jef Claes"
tags = [ "code", "ddd"]
url = "2014/12/spinning-wheel-manipulating-odds.html"
+++
The previous post defined a basic set of data structures and functions
to spin a wheel of fortune in F\#.  
  
There was very little mystery to that implementation though. The
physical wheel had four pockets and spinning the wheel would land you a
win one out of four spins. As a casino, it's impossible to come up with
an interesting payout using this model.  
  
To juice up the pot, casinos started adding more pockets to the wheel of
fortune. This meant that the odds were lower, but the possible gain was
higher. More pockets also allowed casinos to play with alternative
payouts, such as multiple smaller pots instead of one big one.  
  
Adding pockets to the wheel didn't turn out the way casinos hoped for
though. Although players were drawn to a bigger price pot, they were
more intimidated by the size of the wheel - it was obvious that the
chances of winning were very slim now.  
  
Today, instead of having the physical wheel determine randomness,
randomness is determined virtually.  
  
Casinos now define a second set of virtual indexes that map to the
indexes of the physical wheel.  
  
[![](/post/images/thumbnails/2014-12-11-spinning-the-wheel-manipulating-the-odds-SpinningTheWheelManipulatingTheOdds.png)](/post/images/2014-12-11-spinning-the-wheel-manipulating-the-odds-SpinningTheWheelManipulatingTheOdds.png)

```fsharp
let virtualIndexes = [0; 0; 1; 1; 2; 3; 3] |> Seq.ofList
```

There are seven virtual indexes; six map to a miss pocket and only one
maps to a win pocket - one out of seven is a win.  
  
Instead of picking a random index in the physical wheel, we now pick a
random index in the virtual indexes and map that back to an index in the
physical wheel.  

```fsharp
let rng = new Random()       
let random (rng : Random) virtualIndexes = 
	virtualIndexes |> Seq.nth (rng.Next(0, virtualIndexes |> Seq.length))
let spin physicalWheel virtualIndexes rng = 
	physicalWheel |> Seq.nth (random rng virtualIndexes)
```

When we now spin the wheel a million times, the outcome is different.
Although the physical wheel has four pockets, we now only win one out of
seven times or 14% of the time.  

```fsharp
seq [(Miss, 856903); (Win, 143097)]
```

Using this technique, the physical wheel only serves for interaction and
visualization. Randomness is determined virtually, not physically.  
  
In my next post, I'll describe how casinos have tweaked this model to
create "near misses", making players feel as if they just missed the big
pot.
