+++
title = "Defining big wins"
slug = "2015-11-16-defining-big-wins"
published = 2015-11-16T21:31:00.002000+01:00
author = "Jef Claes"
tags = [ "ddd",]
url = "2015/11/defining-big-wins.html"
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

```matlab
multipliers = csvread('C:\data\multipliers.csv')
```

For then to look at its histogram, visualizing how the multipliers are
distributed.  

```matlab
histfit(multipliers)
```

[![](/post/images/thumbnails/2015-11-16-defining-big-wins-hist1.PNG)](/post/images/2015-11-16-defining-big-wins-hist1.PNG)

Here we notice that there is a skewness towards large values; a few
points are much larger than the bulk of data. Logarithmic scales can
help us here.  
  
```matlab
histfit(log(multipliers), 8)
```
  
[![](/post/images/thumbnails/2015-11-16-defining-big-wins-hist2.PNG)](/post/images/2015-11-16-defining-big-wins-hist2.PNG)

This shows us a pretty fitting bell curve, meaning the multipliers are
somewhat log normally distributed. We could now use the log standard
deviation to pick the outliers.  
  
But we can also tabulate the data set and hand pick the cut-off of
normal wins.  

```matlab
tabulate(log(round(multipliers)))

    Value    Count   Percent
        0    54905     21.54%
 0.693147    68548     26.89%
  1.09861    29680     11.64%
  1.38629    16421      6.44%
  1.60944     8900      3.49%
  1.79176     8102      3.18%
  1.94591     2238      0.88%
  2.07944     5953      2.34%
  2.19722     1044      0.41%
  2.30259     3297      1.29%
   2.3979      625      0.25%
  2.48491     1128      0.44%
  2.56495      687      0.27%
  2.63906      544      0.21%
  2.70805      820      0.32%
  2.77259     1402      0.55%
  2.83321      364      0.14%
  2.89037      344      0.13%
  2.94444      185      0.07%
  2.99573     2406      0.94%
  3.04452      162      0.06%
  3.09104      139      0.05%
  ...
```

We could now write a rule in our projection of big wins which states
that a log(multiplier) larger than 3 is considered to be a *big* win.  
  
Matlab, Excel and the like are great domain specific tools for data
exploration which can help you reach a better feel and understanding.
