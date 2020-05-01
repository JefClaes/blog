+++
title = "Book review: Working with NHibernate 3.0"
slug = "2012-02-08-book-review-working-with-nhibernate-3-0"
published = 2012-02-08T20:21:00+01:00
author = "Jef Claes"
tags = [ ".NET", "Bookreview",]
+++
It's been a while since I wrote my last book review, mostly because I'm
still trying to figure out when it adds value to write one. For this one
it was pretty obvious, there are far too little reviews out there.  
  
Being new to NHibernate, and NHibernate being known as having a steep
learning curve, I thought it would be a good idea to do some reading.
Searching for books on NHibernate 3.0 on Amazon only yielded three
results: [NHibernate 3 beginner's
guide](http://www.amazon.com/gp/product/1849516022/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&tag=diofanedebyje-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1849516022),
[NHibernate 3.0
cookbook](http://www.amazon.com/gp/product/184951304X/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&tag=diofanedebyje-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=184951304X)
and [working with NHibernate
3.0](http://www.amazon.com/gp/product/1118112571/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&tag=diofanedebyje-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1118112571).
None of these books have a decent amount of reviews, so I had to pick
judging by the cover and summary. I chose the last one.  
  
The book [Working with NHibernate
3.0](http://the%20book%20working%20with%20nhibernate%203.0%20by%20benjamin%20delcamp%20perkins%20contains%20six%20chapters%2C%20covered%20over%20213%20pages./)
by [Benjamin Delcamp
Perkins](http://thebestcsharpprogrammerintheworld.com/) contains six
chapters, covered over 213 pages.  
  
The first chapter very briefly explains what an ORM is, and then starts
looking at configuring NHibernate. This means setting up the session
factory and its configuration, creating entities and mapping them to the
database (using XML and code), but also configuring log4net
(NHibernate's logging framework), serializing startup and interceptors
and events. These last two subjects felt a little misplaced in this
chapter though.  
  
In the first chapter the foundation for the Guitar store example
application is laid. This example application is written in WPF, which
bothered me a bit. Not because I dislike WPF, but because when I'm
reading a book on a data access technology I really don't want it to be
littered with fragments of XAML and code-behind. To make matters worse,
the author suggests using a console application to test your queries. I
think it would have been far more valuable to use real unit tests to
prove the queries are correct, [more like
this](https://github.com/davybrion/NHibernateWorkshop/tree/master/NHibernateWorkshop).
Another complaint about the example application that I read in another
review is that there are no scripts available to set up the database,
which might be discouraging if you want to follow along.  
  
Chapter two, three and four cover the various NHibernate query API's:
HQL (Hibernate Query Language), ICriteria and LINQ. Every chapter
implements the same or at least similar queries. Concepts covered in
these chapters are simple queries, complex queries, detached queries,
futures and aggregates. I think these chapters succeed in giving a good
overview of the ways you can use NHibernate to query data. Also the tips
on how to use futures, various fetch modes, the stateless session and
aggregates to improve performance will prove useful in the future.  
  
The fifth chapter covers managing state and saving data. In this
chapter, the author explains the various ways you can handle database
concurrency, listing the advantages and disadvantages of each option.
NHibernate caching is also explained, looking at first and second-level
caching. Further in this chapter, you can find an example of a custom
data type implementation. Finally we arrive at saving data with
NHibernate. Next to the standard way of saving data, the author explains
the use of Evict, Merge and Persist.  
  
The last chapter, covering only 9 pages, shows how you should set up
NHibernate in an MVC3 application.  
  
**Conclusion**  
  
Although this book doesn't do a great job showing you how to use
NHibernate in the real world, it does do a decent job giving you a basic
overview of NHibernate's capabilities. Reading this book when you're new
to NHibernate will save you from a few costly common NHibernate
pitfalls. I don't think I will be able to use this book for reference,
but it should be easier now - knowing the correct terminology - to
search in the [NHibernate documentation
online](http://stackoverflow.com/questions/135776/best-place-for-nhibernate-documentation).  
  
**My rating: 3/5.** *Do you advise other books on NHibernate?*
