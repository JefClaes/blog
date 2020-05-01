+++
title = "My InfoQ interview on DDD, events and legacy"
slug = "2016-08-21-my-infoq-interview-on-ddd-events-and-legacy"
published = 2016-08-21T15:07:00.001000+02:00
author = "Jef Claes"
tags = []
+++
Seems that it's impossible to beat the Gaussian curve of blogging
frequency. On the other hand, I spent quite some of my mental blogging
budget on an interview with InfoQ.

  
I'm a bit bummed out that it's such a large wall of text. When
submitting the answers, I highlighted some snippets which should make
for easier scanning. Too bad the formatting was lost when publishing it.
I included some highlights below.  
  
The interview itself can be found
[here](https://www.infoq.com/news/2016/08/software-devs-ddd-drive-business).
Let me know what you think!  

> **Extracting components:** Starting out, this can be as trivial as
> trying to model boundaries as namespaces or modules. 

> **Invariants:** Having core properties enforced deep within the model,
> allows for a better night's sleep.

> **Sizing aggregates:** Make your aggregates as small as they can be,
> but not any smaller. There's a big difference between an invariant
> that needs to be strongly held and data that helps the aggregate to
> make a decision, but which doesn't require strong consistency. 

> **ORM pitfalls:** Being able to navigate through a graph, which
> basically walks through your whole database, is a great way to lose
> any sense of transactional boundaries. 

> **The value of bounded contexts:** Now when I switch between bounded
> contexts, it feels like walking through a door, entering a separate
> room where you can tackle a problem with an unbiased mindset, allowing
> you to use the right tool for the job. 

> **Introducing domain events:** When you don't want to or can't afford
> to invest in the full paradigm shift there's a middle ground. You can
> try a hybrid approach in which you, next to persisting state, also
> persist the events that led up to a specific state. This does entail
> the risk of introducing a bug which causes split-brain in which your
> events do not add up to your state.  

> **Designing contracts:** If you get the semantics wrong, you will end
> up with a system that's held together by brittle contracts that break
> constantly.
