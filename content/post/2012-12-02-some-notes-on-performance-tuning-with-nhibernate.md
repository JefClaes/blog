+++
title = "Some notes on performance tuning with NHibernate"
slug = "2012-12-02-some-notes-on-performance-tuning-with-nhibernate"
published = 2012-12-02T17:36:00+01:00
author = "Jef Claes"
tags = [ "SQL", "Tools", ".NET", "Nhibnerate", "Tips",]
+++
A few weeks back, I spent an intensive day performance tuning parts of
a, to me, relatively unfamiliar part of our codebase. Like it often is,
the biggest optimizations were to be found in how we work with the
database. Now, I don't consider myself to be an NHibernate expert; I
read [this
book](http://www.jefclaes.be/2012/02/book-review-working-with-nhibernate-30.html)
and have used it on two projects, but in the end I just do my best to
avoid doing stupid things with it. The topics discussed below are mostly
common knowledge for long time NHibernate users, but I thought it might
be convenient for others to just summarize them, and add references to
other, more in-detail, posts.  
  
**Under the covers**  
**  
**When you're looking into optimizing, you probably want to have a look
at what's really going on. You could do this by [turning on NHibernate's
log4net debug
logging](http://nhforge.org/wikis/howtonh/configure-log4net-for-use-with-nhibernate.aspx).
This might be good enough for some scenarios, but it's not really
convenient for when there is lots and lots of stuff happening. Instead,
you might want to look into [NHibernate
Profiler](http://www.hibernatingrhinos.com/products/NHProf). It's
trivial to get started with, yet the feedback it provides is very
powerful: next to session statistics and executed queries, you also get
alerts which suggest techniques to improve your code. I need to use this
tool more often just to get a better grip of the NHibernate internals.  
  
**The fastest query is the one that isn't**  
**  
**Going to the database is probably one of the slowest things your
application is going to do. If you can avoid it, do so.  
**  
**If you're using a stateful session, NHibernate will track your
entities, and store them in its [first level
cache](http://nhibernate.hibernatingrhinos.com/28/first-and-second-level-caching-in-nhibernate).
When you get these items by id later on, you avoid going to the
database. So instead of querying the database for the same entity
multiple times in the same session, do it once, and get the entity by
its id on subsequent calls.  
  
When you're having a hard time keeping those ids around, consider
introducing a light-weight datastructure, such as a dictionary, which
can help you build a small look-up cache. This could also be a sign that
you might want to reconsider your identity strategy though.  
  
**Working with batches**  
**  
**An ORM really isn't the best tool to do bulk inserts or updates; look
at
[SqlBulkCopy](http://msdn.microsoft.com/en-us/library/system.data.sqlclient.sqlbulkcopy.aspx)
instead.  
  
If your batches are still relatively small, and you opt to stay with
NHibernate anyways, there are two things you can do which will improve
performance tremendously: use a stateless session and configure
batching.  
  
Switching to a stateless session is simple enough. Do take into account
that [some features won't work
anymore](http://stackoverflow.com/questions/2638950/stateless-nhibernate-for-querying):
lazy loading, caching, cascading and implicit updates. Setting up
batching is also just a matter of
[configuration](http://nhforge.org/blogs/nhibernate/archive/2008/10/27/batching-nhibernate-s-dml-statements.aspx).
The most important thing to remember is to use an appropriate identity
generator; batching will only work when the application is responsible
for generating the ids. I'm using a [HiLo
generator](http://stackoverflow.com/questions/282099/whats-the-hi-lo-algorithm),
but GUIDs or [assigned
ids](http://www.nhforge.org/doc/nh/en/index.html#mapping-declaration-id-assigned)
will work too.
