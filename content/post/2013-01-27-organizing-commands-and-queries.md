+++
title = "Organizing commands and queries"
slug = "2013-01-27-organizing-commands-and-queries"
published = 2013-01-27T18:23:00+01:00
author = "Jef Claes"
tags = [ "code" ]
url = "2013/01/organizing-commands-and-queries.html"
+++
In the last few posts I settled on an architecture for handling commands
and queries. A byproduct of [the described
approach](http://www.jefclaes.be/2013/01/separating-command-data-from-logic-and.html),
is that your codebase quickly racks up plentiful little classes; a class
to hold data, and a handler to act on that data, for each use case.  
  
There are a few ways you can go at organizing things.  
  
### Everything in one location  
  
When there is very little going on in your application, you can just
dump everything in one location without getting hurt too much.    

[![](/post/images/thumbnails/2013-01-27-organizing-commands-and-queries-DumpedEverything.PNG)](/post/images/2013-01-27-organizing-commands-and-queries-DumpedEverything.PNG)
  
### Folder per functionality  

When your application grows, and the coherency between different use
cases are obvious, you can just use folders - and corresponding
namespaces, to organize your commands and queries, and to draw their
functional boundaries. Uncle Bob and Mark Needham have [sold me on
structuring my code based on functionality instead of technical
concepts](http://www.markhneedham.com/blog/2012/02/20/coding-packaging-by-vertical-slice/).  
  
[![](/post/images/thumbnails/2013-01-27-organizing-commands-and-queries-PerFolder.PNG)](/post/images/2013-01-27-organizing-commands-and-queries-PerFolder.PNG)

Keeping each commandhandler in a separate class is especially
interesting when they are rather bulky and contain a good amount of
logic. You can think of each class as a little piece of functionality in
itself. [Take a look at the RavenDB
codebase](https://github.com/ravendb/ravendb/tree/master/Raven.Studio/Commands)
to get an idea of what that could look like.

It also feels like this way tends to bring your code closer to the
Solution Explorer; just one double-click and you are looking at your
implementation; no scrolling or searching between method definitions
necessary. Maybe the problem is now just shifted a level higher in the
hierarchy though.
  
### Composing a service class  
  
You can also opt to group commandhandler implementations in one
service class. This variation might make more sense when your
implementations are rather skinny, and don't do a whole lot but
translating and forwarding your invocation.

```csharp
public class SubscriptionService : 
        ICommandHandler<SubscribeCommand>,
        ICommandHandler<UnsubscribeCommand>
{
    public void Handle(SubscibeCommand command)
    {
        throw new NotImplementedException();
    }

    public void Handle(UnsubscribeCommand command)
    {
        throw new NotImplementedException();
    }
}
```

Use the hints your dependency graph gives you to find a composition that
makes sense.  
  
*How do you go at organizing commands and queries?*
