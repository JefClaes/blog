+++
title = "Strategic DDD in a nutshell "
slug = "2014-02-23-strategic-ddd-in-a-nutshell"
published = 2014-02-23T18:21:00+01:00
author = "Jef Claes"
tags = [ "ddd",]
url = "2014/02/strategic-ddd-in-nutshell.html"
+++
There are two big parts to Domain Driven Design; strategy and tactics.
Strategy helps setting out a high-level grand design, while tactics
enable us to execute on the strategy.  
  
Practicing strategic design, we generally first try to list all of the
different parts that make our business a whole; these are sub-domains.
When you look at a supermarket chain, you would find sub-domains like
real estate management, advertising, suppliers, stock, sales, human
resources, finance, security and so on. Sub-domains will often relate to
existing structures like departments and functions.  
  
Once you've defined your sub-domains, it's useful to determine how
important of a role they play. First of all, you should figure out which
sub-domain is most important to your business; the core domain. This is
the sub-domain that differentiates you from other businesses, or more
bluntly put; this is where the money is at. For our super market chain,
this might not be that obvious for an outsider. A first uneducated guess
would be sales, but if you gave it some more thought, you would realize
that sales are very similar for most supermarkets. Digging deeper, we
would find that supermarkets really compete with each other by squeezing
the last bit of value out of suppliers and by collecting data to use for
targeted advertising. Supplier management and advertising can't stand on
their own though; they need other sub-domains like stock and sales.
These are supporting sub-domains; they are not core, but our business
couldn't do without them either - they still add a bunch of value. Other
sub-domains like property management, human resources or security are
generic sub-domains; these problems have been widely addressed and
solving them yourself won't make you any money.  
  
Having a map of which areas are most important to your business makes it
easy to distribute brain power accordingly. Make sure your core domain
gets the most capable team assigned, before any other supporting
sub-domain. Try to buy solutions of the shelve for generic
sub-domains.  
  
The concept of sub-domains lives in the problem space. The solution
space on the other hand is where bounded contexts are at. Domain Driven
Design tries to define natural boundaries between parts of your solution
by putting the language first. These boundaries allow us to keep a
language and model consistent inside of them, protecting conceptual
integrity.  
If you would ask a marketer what a product is, he would talk about
images, campaigns, weekly promotions and so on. If you'd ask sales on
the other hand, they would only mention price, quantity and loyalty
points. The same concept can turn into something completely different
depending on how you look at it. Bounded contexts enable us to build a
ubiquitous understanding of concepts in a clearly defined context.  
  
Mapping a bounded context to exactly one sub-domain would be DDD
nirvana; addressing one problem with one focused solution. In the real
world, things are more messy though. There will always be systems out of
our control; for example legacy and third party software. As our
understanding of the business grows, keeping our software aligned can be
hard too. If we would lay out a map of sub-domains and bounded contexts
we would see lots of overlap.  
  
Bounded contexts will often be worthless on their own though; most
useful systems exist of interconnected parts. If you have worked in the
enterprise, you know how complex communication between teams and
departments can be. This isn't very different while integrating bounded
contexts; you need to consider politics. This is where concepts like
up-stream, down-stream, bandwidth, partnership, shared kernel,
customer-supplier, conformist, anti-corruption layer etc come into play.
The activity of thinking about and capturing how all these systems play
together is called context mapping.  
In our example, we notice that supplier- and stock management would fail
or succeed together; they have a partnership where the bandwidth is very
high - the teams sit across the hall from each other. Human resources
and security on the other hand have a very different relationship. A
product was bought for human resources, while a solution for security
was outsourced. Security relies quite heavily on what the human
resources' open host service is exposing. If a product version bump
changes those exposed contracts, security needs to comply as soon as
possible; security is down-stream from human resources - shit floats
down-stream.  
  
For me, strategic DDD in one sentence, is the constant exercise of
trying to see and understand your business at large, and aligning your
software as efficiently as possible.
