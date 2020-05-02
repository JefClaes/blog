+++
title = "RavenDB: Drop all collections"
slug = "2013-01-24-ravendb-drop-all-collections"
published = 2013-01-24T20:08:00+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2013/01/ravendb-drop-all-collections.html"
+++
I never stub or mock the database when I'm
using [RavenDB](http://ravendb.net/). Generally, I use an embeddable
documentstore running in memory, and initialize a new instance on every
test. However, I like to run some stress tests against a real instance,
and here I found myself wanting to wipe clean the state of previous
tests, without having to create a new database (which is rather slow).  
  
First I create the default DocumentsByEntityName index to make sure it's
there - it normally gets created when you open the studio for the first
time. Then I use one of the [advanced database
commands:](http://ravendb.net/docs/client-api/advanced/databasecommands) DeleteByIndex,
and query all the tags.  

```csharp
using (var session = _documentStore.OpenSession())
{
        new RavenDocumentsByEntityName().Execute(_documentStore);
        session.Advanced.DatabaseCommands.DeleteByIndex(
                "Raven/DocumentsByEntityName",
                new IndexQuery { Query = "Tag: *" });                
}
```

This technique doesn't seem to be widely used judging by the first page
of Google search results. If there is a reason for that though, let me
know!
