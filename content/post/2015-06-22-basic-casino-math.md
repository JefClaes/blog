+++
title = "Basic casino math"
slug = "2015-06-22-basic-casino-math"
published = 2015-06-22T22:52:00.004000+02:00
author = "Jef Claes"
tags = [ "ddd", "code"]
url = "2015/06/basic-casino-math.html"
+++
In a previous series of posts, I went over the models used by casinos to
spin a wheel
([spinning](http://www.jefclaes.be/2014/12/spinning-wheel.html),
[manipulating the
odds](http://www.jefclaes.be/2014/12/spinning-wheel-manipulating-odds.html),
[clustering and near
misses](http://www.jefclaes.be/2014/12/spinning-wheel-clustering-and-near.html)).
I did not yet expand on the basic mathematical models that ensure a
casino makes money.  
  
Let's pretend we are spinning the wheel again. The wheel has 5 pockets,
and just one of those is the winning one. Given we will be using an
unmodified wheel, you win 1 out of 5 spins. Each bet costs you 1 euro.
Looking at the true odds (1/5), the casino should pay out 4 euro for you
to break even.

```
 - 1M (Loss)
 - 1M (Loss)
 - 1M (Loss)
 - 1M (Loss)
 + 4M (Win)
 = 0M (Total)
 ```
  
Respecting the true odds would not make the casino any money, they pay
out less to ensure that the house has an edge on you. So instead of
paying out 4 euro, it will be a tad less.

```
-  1M (Loss)
-  1M (Loss)
-  1M (Loss)
-  1M (Loss)
+  3M (Win)
= -1M (Total)
```

The **house edge** can be cast into a fairly simple formula.

```fsharp
let houseEdge oddsOfWinning winnings oddsOfLosing stake =
  oddsOfWinning * winnings - oddsOfLosing * stake

houseEdge ( 1M / 5M ) 3M ( 4M / 5M ) 1M |> printfn "%A"

// 0.20M
```

In this example, the house edge is a whopping 20%, meaning statistically
20% of each bet will go to the casino. So the higher the house edge, the
better?  
  
Not really, if players constantly go through their bankroll in a matter
of minutes, it's not very likely they will keep returning to your
casino. The inverse to the house edge, and maybe even a more important
number, is the **payout percentage**. When the house edge is 20%, the
player's payout percentage will be 80%. For each bet you make, you will
statistically see a return of 80%. As a player to get maximum value for
money - to play as long as possible - you should aim to play in a casino
that has the highest payout percentages.  
  
Often misunderstood is that this does not mean you will get to keep 80%
of your bankroll by the end of the night. The payout percentage relates
to a single bet. The casino's **hold**, or money eventually left on the
table, is several times the house edge, since players tend to circulate
through the same money more than once. So the longer you play, the more
the house edge will nibble at your bankroll.  
  
Knowing the house edge, it's pretty simple for a casino to predict a
**customer's worth**; multiply the house edge, the average stake and the
number of games per hour.

```fsharp
let customerValue houseEdge stake handsPerHour =
       houseEdge * stake * handsPerHour

customerValue 0.2M 1M 60M |> printfn "%A"

// 12M
```

Given we spin the wheel 60 times an hour for a stake of 1 euro, we will
make the casino 12 euro an hour on average. The higher this number, the
bigger your potential, the harder a casino will try to make you a
regular.  
  
Understanding how casinos make a living, it's safe to say *casinos
aren't the place to play for money, but to play with money*.