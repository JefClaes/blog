+++
title = "Doing the groceries in parallel"
slug = "2010-05-10-doing-the-groceries-in-parallel"
published = 2010-05-10T20:36:00.010000+02:00
author = "Jef Claes"
tags = [ ".NET", "E-book", "Ramblings", "Best Practices",]
+++
I've started reading the excellent paper "[Patterns for Parallel
Programming: Understanding and Applying Parallel Patterns with the .NET
Framework
4](http://www.microsoft.com/downloads/details.aspx?FamilyID=86b3d32b-ad26-4bb8-a3ae-c1637026c3ee&displaylang=en#filelist)".  
  
There is a section in this whitepaper which explains perfectly why
parallel programming was and still is such an interesting problem.  

> Consider an analogy: shopping with some friends at a grocery store.
> You come into the store with a grocery list, and you rip the list into
> one piece per friend, such that every friend is responsible for
> retrieving the elements on his or her list. If the amount of time
> required to retrieve the elements on each list is approximately the
> same as on every other list, you’ve done a good job of partitioning
> the work amongst your team, and will likely find that your time at the
> store is significantly less than if you had done all of the shopping
> yourself. But now suppose that each list is not well balanced, with
> all of the items on one friend’s list spread out over the entire
> store, while all of the items on another friend’s list are
> concentrated in the same aisle. You could address this inequity by
> assigning out one element at a time. Every time a friend retrieves a
> food item, he or she brings it back to you at the front of the store
> and determines in conjunction with you which food item to retrieve
> next. If a particular food item takes a particularly long time to
> retrieve, such as ordering a custom cut piece of meat at the deli
> counter, the overhead of having to go back and forth between you and
> the merchandise may be negligible. For simply retrieving a can from a
> shelf, however, the overhead of those trips can be dominant,
> especially if multiple items to be retrieved from a shelf were near
> each other and could have all been retrieved in the same trip with
> minimal additional time. You could spend so much time (relatively)
> parceling out work to your friends and determining what each should
> buy next that it would be faster for you to just grab all of the food
> items in your list yourself.

  
Of course, we don’t need to pick one extreme or the other. There are
dozens of variations on these two extremes. Think about how hard it must
be to come up with an algorithm which always takes the most efficient
path for any given scenario.  
  
Food for thought..
