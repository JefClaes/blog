+++
title = "IDDD Tour notes (2/2)"
slug = "2013-05-12-iddd-tour-notes-2-2"
published = 2013-05-12T15:44:00+02:00
author = "Jef Claes"
tags = [ "DDD", "Ramblings",]
+++
This is the second and last part of my notes I scribbled down attending
the IDDD Tour. [The first
part](http://www.jefclaes.be/2013/05/iddd-tour-notes-12.html) was
published last week.  
  
**A better model**  

> Even if you come up with a better model, the fact that it has been the
> ubiquitous language of the domain for decades proves that it works for
> them.

This quote bothers me a bit. There definitely is truth to this, but
modeling an existing process often presents such a great opportunity to
revise and improve it. Naked models don't conceal deficiencies,
inefficiencies and aberrations. Exploring alternative models free of
habituation, politics and legacy is dirt cheap, while the outcome could
considerably benefit all. It seems such a shame not to take advantage of
this. As with most things, know when to pick your fights.  
  
**Elegance**  

> Elegance is for dressing, not for delivering software.

This is one to remember; I'll be using this one next time someone uses
elegance as an argument for gold plating.  
  
**Cultivating models**  

> Models grow; you will never have the best model from the start.
> Improve them every time you pass by.

Your first attempt at it is hardly ever right. Don't beat yourself up
over it. The best models are the result of multiple iterations. <span
class="Apple-tab-span" style="white-space: pre;"> </span>  
In general I consider dwelling on one problem too long to be a waste of
time. Settle for good enough, and allow the better solution to emerge by
itself over time.  
When I feel a design is mighty important, I might accelerate this
process by iterating over it multiple times in just a few days; asking
for constant feedback, carrying the problem with me everywhere I go,
always challenging it, and molding it in different shapes until one
sticks.  
  
**Reuse**  

> Lots of people use a shared kernel just for reuse. It's often not
> worth it.

People are so obsessed with the DRY principle, and the dogma of avoiding
duplication, it often does more harm than good. Nonexistent concepts are
introduced just to spare a few duplicate lines of code, while they will
hinder and complicate autonomous evolution.  
  
**REST and DDD<span class="Apple-tab-span" style="white-space: pre;">
</span>**  

> Don't expose your domain model over REST: expose use cases. 

You want to enable relentlessly evolving your domain model without
breaking clients. In practice you would post intent-revealing command
resources, while hypermedia guides you in navigating to subsequent
commands.  
  
**Published language**  

> How is the language agreed upon; over lunch or by a committee?

 A great question which reveals if a language should be really
considered as published.  
  
*And that's the last of it. If you thought some of these were
interesting, you should probably [get the
book](http://www.amazon.com/gp/product/0321834577/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321834577&linkCode=as2&tag=diofanedebyje-20).
I finished [Growing Object-Oriented Software Guided by
Tests](http://www.amazon.com/gp/product/0321503627/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321503627&linkCode=as2&tag=diofanedebyje-20)
last week, so I finally get to read it myself after having it collect
dust for two months.*
