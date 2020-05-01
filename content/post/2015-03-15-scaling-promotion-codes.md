+++
title = "Scaling promotion codes"
slug = "2015-03-15-scaling-promotion-codes"
published = 2015-03-15T18:01:00.001000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "DDD",]
+++
In our system a backoffice user can issue a promotion code for users to
redeem. Redeeming a promotion code, a user receives a discount on his
next purchase or a free gift. A promotion code is only active for a
limited amount of time, can only be redeemed a limited amount of times
and can only be redeemed once per user.  

  

In code these requirements translated into a promotion code aggregate
which would guard three invariants.

  

The command handler looked something like this.

  

Depending on the promotion code, we would often have a bunch of users
doing this simultaneously, leading to a [hot
aggregate](http://www.jefclaes.be/2014/11/splitting-hot-aggregates.html),
leading to concurrency exceptions.  
  
Studying the system, we discovered that the limit on the amount of times
a promotion code could be redeemed was not being used in practice.
Issued promotion codes all had the limit set to 999999. Just by looking
at production usage, we were able to remove an invariant, saving us some
trouble.  
  
The next invariant we looked at, is the one that avoids users redeeming
a promotion code multiple times. Instead of this being part of the big
promotion code aggregate, a promotion code redemption now is a separate
aggregate. The promotion code aggregate now picks up a new role; the
role of a factory, it decides on the creation of new life.

  

The promotion code redemption's identifier is a composition of the
promotion code identifier and the user identifier. Thus even when the
aggregate is stored as a stream, we can check in a consistent fashion
whether the aggregate (or stream) already exists, avoiding users
redeeming a promotion code multiple times. On creation of the stream,
the repository can pass to the event store that it expects no stream to
be there yet, making absolutely sure we don't redeem twice. The event
store would throw an exception when it would find a stream to already
exist (think unique key constraint).

  

In this example, we were able to remove an annoying and expensive
invariant by looking at the data. Even if we had to keep supporting
promotion code depletion, we might have removed this invariant and
replaced it with data fed into the aggregate/factory from the read
model. Ask yourself, how big is the cost of having a few more people
redeem a promotion code? Teasing apart the aggregate even further, we
discovered that the promotion code had a second role; a creational role.
It now helps us spawning promotion code redemptions while still making
sure this only happens when the promotion code is active. Each promotion
code redemption is now a new short-lived aggregate, while the promotion
code itself stays untouched. By checking the existence of the aggregate
up front and by using the stream name to enforce uniqueness, we avoid
users redeeming a promotion code more than once. This has allowed us to
completely avoid contention on the promotion code, making it perform
without hiccups.
