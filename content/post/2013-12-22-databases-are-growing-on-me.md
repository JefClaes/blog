+++
title = "Databases are growing on me"
slug = "2013-12-22-databases-are-growing-on-me"
published = 2013-12-22T21:53:00+01:00
author = "Jef Claes"
tags = [ "database", "Bookreview", "Ramblings",]
+++
I learned all about logical design of relational databases back in
school; tables, columns, data types, views, normalization, constraints,
primary keys, foreign keys... At the same time, I learned how to use SQL
to put data in, and how to get it out again; INSERT INTO, SELECT, FROM,
WHERE, JOIN, GROUP...  
  
In the first project I worked on just out of school, we weren't doing
anything interesting with databases; we didn't have that many users, or
that much data. A database veteran on the team took it on him to
maintain the schema and to provide stored procedures we could do work
with.  
  
All that time, I consciously was very ignorant of the database. I had no
idea what was in the box, and I didn't care either; databases were
boring, applications were where the fun was at.  
  
Since then, I have rarely worked with a team that had a dedicated role
for database design. Why invest in another person when you can do
without? Database basics are not rocket science; with 20% of the
knowledge, you get very far. Definitely now that it's probably easier
and cheaper to throw hardware at the problem.  
  
That being said, it's a good idea to keep a DBA close. Time and time
again I see them only being called in when it's too late and much needed
improvements are often too far-reaching and expensive. No wonder DBA's
are grumpy all the time.  
  
Being exposed to databases more and more, I got to pick up a few things
here and there - mostly cargo-cult best practices. It wasn't until last
year that I got really curious for what was in the box. Working on an
application with a decent amount of data crunching for a year forced me
to open up the lid. Also my ventures in NoSQL land, overhearing
discussions on Twitter between
[kellabyte](https://twitter.com/kellabyte),
[ayende](https://twitter.com/ayende),
[gregyoung](https://twitter.com/gregyoung), [pbailis](https://twitter.com/pbailis) and
others had much to do with it.  
  
On opening the lid, I found a lot more than I expected. It had never
occurred to me how much interesting problems databases have to solve.
Making a database execute a query and see results returned in
milliseconds only looks easy on the surface. Memory, disk, CPU, caching,
networking, protocols, concurrency, fault tolerance, data structures,
transactions, compilation... it's all in there.  
  
The book [Physical Database
Design](http://www.amazon.com/gp/product/0123693896/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0123693896&linkCode=as2&tag=diofanedebyje-20)
and the [SQLite technical
documentation](http://www.sqlite.org/docs.html) were the first good
reads that helped me understand what was going on closer to the metal.
From there, I now try reading a paper (or a reference) from the
[Readings in Database Systems](http://redbook.cs.berkeley.edu/bib4.html)
collection once in a while. This collection of papers is supposed to
contain the most important papers in database research. Maybe academic,
but delicious brain food nonetheless - stretching my mind in ways I'm
not used to.
