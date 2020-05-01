+++
title = "Repositories, where did we go wrong?"
slug = "2014-01-26-repositories-where-did-we-go-wrong"
published = 2014-01-26T18:00:00+01:00
author = "Jef Claes"
tags = [ "database", "DDD",]
+++
In essence, repositories are a simple abstraction over aggregate
storage. A repository will insert, update, delete or fetch an aggregate
from the underlying persistence mechanism. This abstraction avoids that
databases, SQL statements, Object Mappers and the like leak into your
domain. Next to that, swapping out repositories for an in-memory version
makes testing easier.  
  
Recently, the use of repositories is being questioned again.  
  
Why would we wrap Object Mappers in yet another abstraction? Aren't
Object Mappers already an implementation of the repository pattern? In a
recent project, we left out repositories. In that project we're using
RavenDB, which already has an expressive API, and which can be
configured to use an in-memory database for testing. Even though LINQ
and indexes help make simple queries expressive, a lot of cruft still
leaks in, not doing the language any justice. In other projects, we did
make use of repositories over our ORM. Partly because setting up
in-memory tests without was awkward at best, but also because it removed
constraints trying to capture the language. Next to testing and
expressiveness, you should also consider how comfortable you feel gluing
everything to a library or framework. When it comes to aggregate
storage, having those repositories is a small price to pay to keep
technicalities out.  
  
Another remark is that a repository makes it hard to control eager- and
lazy loading, which is contextual. In general I think that lazy loading
introduces unpredictable behaviour. Getting in trouble without lazy
loading is a strong indication that your aggregates are just too big.  
  
The last and loudest argument is that once you have a view heavy
application things get dirty really fast. It starts by adding a few
badly named query methods on your repositories. Then, you start to see
use cases where you need to query over multiple aggregates and deal with
projections or aggregations. In these situations repositories won't help
you.  
Truth is that repositories were never intended for complex reads. Views
on the data that your application needs rarely resemble the structure of
your aggregates. Making your aggregates suited for querying inevitably
steers away from behaviour thinking, back to data thinking. The trick is
to separate read concerns from your domain. Instead of trying to use
repositories for querying, make use of the best tool for the job,
something as close to the database as possible. The implementation
depends on your flavor, but what has worked for me is having use case
optimized read models, a query object and a query handler that reads
from the database and converts the result into a read model. The
implementation of each query handler can differ; from raw SQL, to
hibernate query language, to a micro ORM... whatever works best
really.  
Doing this, you allow your domain model to stay focused on the task at
hand - handling complex business problems, staying far away from read
concerns. Before you know it you're successfully applying [that popular
four letter
acronym](http://www.jefclaes.be/2013/02/adding-r-to-cqs-some-storage-options.html),
enabling you to even try [other
concepts](http://www.jefclaes.be/2013/10/my-understanding-of-event-sourcing.html)
without having to rewrite your model completely.
