+++
title = "IDDD Tour notes (1/2)"
slug = "2013-05-05-iddd-tour-notes-1-2"
published = 2013-05-05T17:10:00+02:00
author = "Jef Claes"
tags = [ "DDD", "Ramblings",]
+++
Two weeks ago I got to spend four days attending the [IDDD
Tour](http://idddtour.com/) by [Vaughn
Vernon](https://twitter.com/VaughnVernon). Although my book queue has
only allowed me to shallowly browse [the
book](http://www.amazon.com/gp/product/0321834577/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321834577&linkCode=as2&tag=diofanedebyje-20),
I had high hopes for this course. I anticipated a week of getting
lectured on DDD with a few practical exercises, but was blown away by
the openness and interaction promoted by Vaughn and his associate
[Alberto Brandolini](https://twitter.com/ziobrando). A passionate group,
engaging workshops, long days and lots of sharing made these few days
exceptionally satisfying and inspirational. I'm grateful to those who
got this show on the road; it was more than worth your trouble.  
  
Over these few days I scribbled down some things I thought were worth
remembering or worth some more thought. Most of these are aimed at the
strategic side of DDD and the softer side of software since that's where
I acquired most new insights.  
  
**Complexity**  

> If we really understood the complexity of a system, we would very
> often make different decisions from when designing new systems. 

Understanding the complexity of a new system is hard. Modeling can serve
as the perfect tool to help you expose the hidden complexities as early
as possible.  
Often a system appears to be not much more than CRUD, to quickly evolve
into something with a lot more behaviour than anticipated. Make sure you
don't sabotage growing your design by picking an architecture or
framework that doesn't allow you to.  
I often start with just exposing commands and queries to my application,
which encapsulate all domain logic. Behind these command- and
queryhandlers is very little abstraction, just some basic building
blocks; aggregates, entities and value objects. Later on I can
relentlessly refactor everything behind these commands and queries
without breaking application code: introduce domain services, events,
separate the write- from the read model etc...  
  
**Change**  

> How do you bring in DDD? Gather a small cluster of motivated silent
> people and work on a project that has lots of potential value.

This is my recipe for change as well. Find a few like-minded people that
are confident drawing outside the lines set out by the status quo, work
in the shades, working your way towards the light.  
  
**Brown**  

> There is always brown, even when it's under the green. 

Every application has parts which are less pretty, even green fields;
use proper encapsulation to contain them, and avoid them corrupting
other parts of the system.  
  
** Another brick in the wall**  

> Break down that paper wall between domain experts and developers.
> Learn the favorite coffee of the domain expert.

Lots of organizations still build this paper wall between domain experts
and developers. But paper doesn't answer to questions, nor does it carry
nuances very well. Communicating on a more personal level is key to
tearing down that wall. Breaking the ice can be as easy as treating your
domain expert to coffee.  
  
**One language**  

> Which language do you use when naming things in code? Yours. 

I don't think native English speakers understand just how awkward it is
to write code in something other than English. Keywords, API's,
documentation... it's all in English. I feel that putting these together
with your own language results in a cacophony of words.  
In my current project the business is bilingual; they use Dutch and
French names for the same concept interchangeably. We tried to find
middle ground by introducing English names, and have a map between these
languages. Ideally there would only be one language though.  
Someone mentioned that they use English for all globally unambiguous
concepts such as account number, name... but use their mother tongue in
scenarios where nuances would be lost in translation. This seems to be
an attractive compromise.  
  
**Defining a bounded context**  

> A bounded context is where one ubiquitous language is consistent.

This is by far the simplest definition of a bounded context. <span
class="Apple-tab-span" style="white-space: pre;"> </span>  
  
**Bounded context relations**  

> You say please, so I am upstream.

The [relationship between bounded
contexts](http://www.markhneedham.com/blog/2009/03/30/ddd-recognising-relationships-between-bounded-contexts/)
is expressed by saying one is upstream or downstream. I thought of the
quote above to be a creative expression that can aid in explaining these
two concepts.  
  
**Rewrites**  

> When you rewrite an application, you have to look at the existing
> forces in an organization; chances are the previous team wasn't
> terrible either.

Tons of factors influence the outcome of a project; it's not just about
teams and their skillset. Some forces in an organization can make it
close to impossible to ship good software; fear of change, lack of
vision, bone-dry information streams... So don't assume your rewrite
will fix everything.  
  
**Surprise**  

> Adding surprise value is often not that valuable.<span
> class="Apple-tab-span" style="white-space: pre;"> </span>

This seems to be related to the mantra of 'good enough'. Sometimes we -
with the best intentions - invest more time and money in solving a
problem in the best possible way, than it will ever return.  
  
*These were some notes I wrote down the first two days. I'll try to go
through the other half over these next few days. I hope you found some
of them valuable too.*
