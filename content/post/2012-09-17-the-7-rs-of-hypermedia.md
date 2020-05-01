+++
title = "The 7 R's of Hypermedia"
slug = "2012-09-17-the-7-rs-of-hypermedia"
published = 2012-09-17T21:42:00+02:00
author = "Jef Claes"
tags = [ "ASP.NET MVC", "REST", "Web API",]
+++
While most [REST
concepts](http://www.jefclaes.be/2012/09/slides-and-code-from-my-tunisia-rest.html)
are rather easy to grok, there is one concept which I found harder to
understand at first: Hypermedia. Let it be that without this concept,
you're missing out on an extremely important strength of REST.
Hypermedia enables you to build dumb - or smart, depending on your
perspective - clients, which are mostly driven by the server.
Practically, this is implemented as resources embedding links which
allow the client to discover and navigate through your RESTful
service.  
  
Accidentally actually, I saw [someone](https://twitter.com/tourismgeek)
tweet a link over the weekend to a [Deep Fried
Bytes](http://deepfriedbytes.com/) episode, featuring [Darrel
Miller](http://www.bizcoder.com/), where he talks about the seven R's of
Hypermedia. I listened to it on my morning commute, and the 56 minutes
long show contained one of the best summaries on the uses of Hypermedia
I've heard or read so far.  
  
Here are some of my notes...  

1.  **R**elations: Make your service discoverable and self-documenting
    by embedding links to related concepts.
2.  Embedded **r**esources: Instead of embedding resources (for example:
    a company logo) into your client, and having to deal with specific
    storage techniques, make them available through your service and use
    built-in HTTP caching.
3.  **R**eference data: Provide links to where your client can find
    optional or required reference data. Populating a dropdownlist is a
    good example. 
4.  **R**edistribution of effort: Instead of putting a dumb load
    balancer in front of your machines, you can use your links to refer
    certain functionality to a specific machine.
5.  **R**eduction of payload size: Show clients where they can get extra
    data. Think endless scrolling, or more detailed resources.
6.  **R**eflow: Allow the server to control the flow. The server can use
    links to dictate the next available steps in a business process. 
7.  **R**estriction of functionality: The client can derive from the
    presence of a certain link whether a certain functionality is
    enabled or disabled.

You can find the full show
[here](http://deepfriedbytes.com/podcast/episode-90-going-through-the-7-r-rsquo-s-of-hypermedia-with-darrel-miller/).
