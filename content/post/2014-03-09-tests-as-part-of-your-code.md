+++
title = "Tests as part of your code"
slug = "2014-03-09-tests-as-part-of-your-code"
published = 2014-03-09T18:13:00+01:00
author = "Jef Claes"
tags = []
+++
In the last project I worked on - processing financial batches - we put
a lot of effort in avoiding being silently wrong. The practice that
contributed most was being religious about avoiding structures to ever
be in an invalid state. Preconditions, invariants, value objects and
immutability were key.  
  
One of the things we had to do with these structures was writing them to
disk in a specific banking format; all the accounts with their
transactions for a specific day. To verify the outcome of these
functions, we had a decent test suite in place. But still, we felt like
we had to do more; the person on the team that had been working in this
domain for thirthy years had been relentlessy empathizing - nagging -
that bugs here would be disastrous, and would have us end up in the
newspaper. That's when we decided to add postconditions, putting the
tests closer to the production code. These would make sure we crashed
hard, instead of silently producing something that was wrong.  
  
To make sure we correctly wrote all transactions for one account to
disk, we added a postcondition that looked something like this.  

    Ensure.That(txSumWrittenToDisk.Equals(account.Balance.Difference()));

A few weeks later, running very large batches in test, we had this
assertion fail randomly. An account can have hundred thousands of
transactions a day. This is why the account structure did not contain
its transactions - there were too many to hold them in memory. To make
sure an account and its transactions added up, we did do set validations
earlier on - no faulty state there. Since the assertion would only fail
randomly, and the function had no dependencies on time or mutable state,
the only culprit could be data feeded into the function. Since all
transactions for one account wouldn't fit in memory, we were streaming
them in pages from the database, and this is where we forgot to sort the
whole result first, resulting in random pages - doh.  
  
Without this postcondition, we probably would have ended up in the
newspaper. While putting your code under test is super valuable, having
some crucial assertions as integral part of your code might strengthen
it even more(\*).  
  
*\* This concept is central to
the [Eiffel](http://en.wikipedia.org/wiki/Eiffel_(programming_language)#Design_by_Contract) programming
language.*
