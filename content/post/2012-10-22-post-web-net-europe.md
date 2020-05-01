+++
title = "Post Web.NET Europe"
slug = "2012-10-22-post-web-net-europe"
published = 2012-10-22T20:35:00.001000+02:00
author = "Jef Claes"
tags = [ ".NET", "ASP.NET", "Ramblings", "Travel",]
+++
I attended and
[spoke](http://www.jefclaes.be/2012/10/slides-and-code-from-my-webnet-europe.html)
at [Web.NET Europe in Milan](http://webnetconf.eu/) over the weekend.
This was only my fourth full day- or more conference (Techdays Belgium,
[TechEd
Berlin](http://www.jefclaes.be/2010/11/teched-europe-2010-day-3.html)
and [HTML5
WebCamps](http://www.jefclaes.be/2011/04/video-slides-and-source-from-my.html)),
but it was undoubtedly the best one so far.  
  
The quality of the sessions was definitely not inferior to those of
bigger conferences. I especially enjoyed the talks on SignalR, OAuth and
scaling data (I included some of my notes below). The strength of this
conference doesn't lie in the exceptional speakers or sessions though,
but in its cozy size and the type of attendees it attracts. Being hosted
on a Saturday, you already preclude all the developers who merely think
of technology as a job. And when you put together those who care about
what they do, and want to get better at it, good things happen. This was
the first conference where I was able to talk to such a wide range of
people - I guess I even spoke to more than six different nationalities -
and where it didn't feel awkward one bit. What helps in attracting such
a variety of people, is that the conference is practically free and
survives on donations from sponsors and attendees, making it very
affordable even if you fly in from outside of Italy. Freelancers also
seemed to appreciate that it was on a non-billable day.  
  
In short, I really enjoyed the experience, and it might be just so that
*weekend conferences* make for better conferences. Congratulazioni a
[Simone Chiaretta](https://twitter.com/simonech) and [Ugo
Lattanzi](https://twitter.com/imperugo) for making this happen. I'm
already looking forward to the next edition.  
  

[![](../images/thumbnails/2012-10-22-post-web-net-europe-WebDotNet.jpg)](../images/2012-10-22-post-web-net-europe-WebDotNet.jpg)

  

------------------------------------------------------------------------

  
**"Real Time" Web Applications with SignalR in ASP.NET**
([@A\_Giorgetti](https://twitter.com/A_Giorgetti))  
  
Last year I did a talk on [WebSockets at HTML5
WebCamps](http://www.jefclaes.be/2011/04/video-slides-and-source-from-my.html)
and although I built a few things that worked, the real-time web in the
wild was still very much a mess. [SignalR](http://signalr.net/) now
abstracts all that clutter for you, and provides you with a seemingly
clean infrastructure and simple API. Too bad the use for real-time web
applications is rather limited in my world - stock ticker or chat
application anyone?  
  
**OAuth-as-a-service using ASP.NET Web API and Windows Azure Access
Control** ([@maartenballiauw](https://twitter.com/maartenballiauw))  
  
I had my first serious look at [OAuth](http://oauth.net/) in this
session, and while it's probably indispensable for public API's, it
doesn't seem that trivial to implement. [Azure
ACS](http://www.windowsazure.com/en-us/develop/net/how-to-guides/access-control/) could
make this easier though.  
  
*[Slides](http://www.slideshare.net/maartenba/oauthasaservice-using-aspnet-web-api-and-windows-azure-access-control-webnetconf)*  
  
**Scaling without going crazy**
([@Ayende](https://twitter.com/ayende))  
  
This was one of the talks I really looked forward to, and it didn't
disappoint one bit. I never got to do anything with big data (data that
can't fit on one machine), but there are really interesting problems and
trade-offs in that space - [CAP
theorem](http://en.wikipedia.org/wiki/CAP_theorem) etc.  
  
Some quotes worth giving more thought:  

-   Caching often just hides a problem.
-   How is Facebook consistent? It's personally consistent.
