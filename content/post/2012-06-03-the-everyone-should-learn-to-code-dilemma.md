+++
title = "The 'everyone should learn to code' dilemma"
slug = "2012-06-03-the-everyone-should-learn-to-code-dilemma"
published = 2012-06-03T16:40:00+02:00
author = "Jef Claes"
tags = [ "opinion",]
url = "2012/06/everyone-should-learn-to-code-dilemma.html"
+++
Back when I was working on software for fire departments, we started
thinking about reworking a critical piece of our solution: deployment
plans. In a fire department domain, deployment plans help to make a
suggestion to the dispatcher about which units should be dispatched to a
location when an incident is called in. The suggested composition of
units depends on a wide range of variables: availability, response time,
ranks, type of incident, required tools, ... , even politics.
Originally, people high enough in rank could compose these plans using a
decision tree-like UI. However, as it turned out, this UI was
insufficient; not all variables and conditions were available. Since
this was no custom built tool, we had to work around it by composing
incomprehensible decision trees or by tricking the underlying services.
When talking about how we could do better, we hit a wall pretty soon. We
thought about building our own - but more extensive - UI, and damn, even
designing a DSL crossed our minds. 
 
Along the process, I heard that [Configuration Complexity
Clock](http://mikehadlow.blogspot.co.uk/2012/05/configuration-complexity-clock.html)
ticking, and I couldn't stop myself from thinking that if everyone knew
how to code - just some boolean logic and control flow would suffice -,
we wouldn't have gotten into this mess. It seemed impossible to build
something that would be intuitive, and still fulfill all the
requirements; some things just seem to be best expressed in code.  
  
I empathize with the [proponents of teaching everyone how to
code](http://sachagreif.com/please-learn-to-code/). On the other hand,
I've been watching this movement from a safe distance; there are two
sides to the same coin.  
  
Just a few weeks ago, a peer shared one of those horror stories which
originate when non-professional developers take matters into their own
hands. The IT department of this big company was looking for a piece of
software which could standardize the way employees make hardware and
support requests. Shopping around, they found the existing products
couldn't satisfy their needs, or they would take a considerable cut out
of their yearly budget. Eventually, a system administrator who knew just
enough about programming to be dangerous stepped up, and rolled his own
tool. For over two years, all was good with the world. Maybe the
solution wasn't very pretty, and a bit on the slow side, but overall -
and most importantly - it got the job done. Now, the original developer
has decided he can't be bothered maintaining his brainchild any longer.
The peer who told me this story, was also the guy chosen to take over
maintenance and feature requests. They assured him that it wouldn't be
too much trouble; just a little feature here and there, and maybe the
exceptional bug. What he found however, were the things nightmares are
made of; a - classic - ASP.NET web application with just one web page,
written in VB.NET, containing over 20k LOC, with updatepanels nested
five levels deep.  
  
And this is the perfect example of how we have to be very careful with
the 'everyone should learn to code' meme. **Slinging code is easy, but
writing good code is hard**, and takes a lot of practice. [Software
might be eating up the
world](http://online.wsj.com/article/SB10001424053111903480904576512250915629460.html),
but maybe it's for the best we don't turn it into a monstrous glutton.
