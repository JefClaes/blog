+++
title = "Painless database logging with mongoDB"
slug = "2012-05-20-painless-database-logging-with-mongodb"
published = 2012-05-20T17:18:00+02:00
author = "Jef Claes"
tags = [ "code", "infrastructure"]
url = "2012/05/painless-database-logging-with-mongodb.html"
+++
While browsing the source code of the [ELMAH mongoDB
provider](https://github.com/CaptainCodeman/elmah-mongodb), I learned
about a special type of collections: capped collections.  
  
From the [mongoDB documentation](http://www.mongodb.org/display/DOCS/Capped+Collections):  

> Capped collections are fixed sized collections that have a very high
> performance auto-FIFO age-out feature (age out is based on insertion
> order). In addition, capped collections automatically, with high
> performance, maintain insertion order for the documents in the
> collection; this is very powerful for certain use cases such as
> logging.

This is such a killer feature. Logging to the database can be extremely
useful, but also rather expensive. Using this feature, you can turn on
database logging without too many worries.  
  
Insertion into a capped collection is ridiculously fast. To get an idea
of how fast it really is, I did some measuring on my own humble machine.
I managed to insert 10.000 small documents in *less than 3.7 seconds*.
The headaches of tweaking buffer sizes and rolling asynchronous
appenders seem to be miles away.  
  
Something which religiously gets ignored until shit hits the fan, is log
table maintenance. With a capped collection there is no need to set up a
database job that periodically cleans the logging table. You just set a
fixed size, and you're done. No more middle-of-the-night support calls
when the logging table is eating up all the disk space.  
  
Creating a capped collection with the C\# driver can look like this.  

```csharp
var server = MongoServer.Create("mongodb://localhost/");
var db = server.GetDatabase("PlayGround");

var options = CollectionOptions
    .SetCapped(true)
    .SetMaxSize(5000)
    .SetMaxDocuments(100);

if (!db.CollectionExists("Log"))
    db.CreateCollection("Log", options);
```

Now that's easy sailing.