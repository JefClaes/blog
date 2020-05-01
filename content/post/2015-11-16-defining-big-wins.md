+++
title = "Defining big wins"
slug = "2015-11-16-defining-big-wins"
published = 2015-11-16T21:31:00.002000+01:00
author = "Jef Claes"
tags = [ "DDD",]
+++
Casinos invest a lot of energy selling the dream. One way to do this is
by showing off people winning big in your casino. Everyone has seen
those corny pictures of people holding human-sized cheques right? It's a
solid tactic, since empirical evidence shows that after a store has sold
a large-prize winning lottery ticket, the ticket sales increase from 12
to 38% over the following weeks.  
  
If we look at slot machine play, what exactly defines a big win? The
first stab we took at this was quite sloppy. We took an arbitrary number
and said wins bigger than 500 euro are impressive. This was quick and
easy to implement, but when we observed the results we noticed that when
you have players playing at high stakes, a win of 500 euro really isn't
that impressive, and we would see the exceptional high roller often
dominate the results.  
  
What defines a big win, is not the amount, but how many times the win
multiplies your stake. Betting 1 euro to win 200 euro sounds like quite
the return right? Coming to this conclusion, we had to define a
multiplier threshold that indicates a big win.  
  
Having each win correlate to a bet, we could project the multipliers,
and look at the distribution.  
  
In this example I'm using matlab, but we could do the same using Excel
or code.  
  
So first we load the multipliers data set.

  

For then to look at its histogram, visualizing how the multipliers are
distributed.  
  

  

[![](/post/images/thumbnails/2015-11-16-defining-big-wins-hist1.PNG)](/post/images/2015-11-16-defining-big-wins-hist1.PNG)

  
  
Here we notice that there is a skewness towards large values; a few
points are much larger than the bulk of data. Logarithmic scales can
help us here.  
  

  

[![](/post/images/thumbnails/2015-11-16-defining-big-wins-hist2.PNG)](/post/images/2015-11-16-defining-big-wins-hist2.PNG)

This shows us a pretty fitting bell curve, meaning the multipliers are
somewhat log normally distributed. We could now use the log standard
deviation to pick the outliers.  
  
But we can also tabulate the data set and hand pick the cut-off of
normal wins.  
  

We could now write a rule in our projection of big wins which states
that a log(multiplier) larger than 3 is considered to be a *big* win.  
  
Matlab, Excel and the like are great domain specific tools for data
exploration which can help you reach a better feel and understanding.
