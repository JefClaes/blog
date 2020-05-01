+++
title = "TechEd Europe 2010: Day 2"
slug = "2010-11-11-teched-europe-2010-day-2"
published = 2010-11-11T10:00:00.001000+01:00
author = "Jef Claes"
tags = [ "teched",]
+++
In this post you can find information on the sessions I attended at
[TechEd Europe](http://www.microsoft.com/europe/teched/) <span
style="font-style:italic;">yesterday</span>. I tried to give a very
brief summary per session accompanied with some interesting links you
can use to find more information on the subject.  
  
<span style="font-weight:bold;">Architecture Discovery with Visual
Studio 2010 Ultimate</span>  
  
In the first session of the day [Peter
Provost](http://www.peterprovost.org/) demoed the most important
architecture discovery features in [Visual Studio 2010
Ultimate](http://www.microsoft.com/visualstudio/en-us/products/2010-editions/ultimate):  
- [DGML dependency
graphs](http://blogs.msdn.com/b/jasonz/archive/2010/02/02/favorite-vs2010-features-dependency-graphs-and-dgml.aspx)  
- [Architecture
explorer](http://netindonesia.net/blogs/wely/archive/2010/06/22/architectural-features-in-vs2010-part-2-architecture-explorer.aspx)  
- [Layer
diagram](http://blogs.u2u.be/peter/post/2010/01/19/Using-the-Visual-Studio-2010-layer-diagram-to-verify-your-solution.aspx)  
- [UML
modeling](http://weblogs.asp.net/gunnarpeipman/archive/2009/11/04/visual-studio-2010-uml-modeling-projects.aspx)  
  
I really need to try this out on my own solutions as soon as I get back
to Belgium!  
  
<span style="font-weight:bold;">Usability, SEO, Security: Common RIA and
Ajax mistakes (and fixes)</span>  
  
[Christian Wenz](http://twitter.com/#!/chwenz) composed a list of common
RIA and Ajax mistakes. Next to pointing out the mistakes, he also
demonstrated how you can fix them.  
  
Problems he talked about are:  
- Bookmarks and maintaining state: You could maintain state using
[cookies](http://en.wikipedia.org/wiki/HTTP_cookie), but that is kind of
nasty. It's better to use [url
hashes](http://ajaxpatterns.org/Unique_URLs) to get the job done.  
- Back and forward buttons: In most AJAX applications the browsers back
and forward buttons don't work as they should. The easiest way to make
this work is by using the [ASP.NET
ScriptManager](http://msdn.microsoft.com/en-us/magazine/cc163354.aspx)
to [enable
history](http://dotnetslackers.com/articles/aspnet/AFirstLookAtASPNETExtensions35HistoryPoints.aspx).
The client-side alternative for this comes in the form of a jQuery
plug-in ([BBQ](http://benalman.com/projects/jquery-bbq-plugin/),
[hasChange](http://benalman.com/projects/jquery-hashchange-plugin/) or
[history](http://tkyk.github.com/jquery-history-plugin/)).  
- Concurrent HTTP requests: Because browsers limit the number of
concurrent HTTP requests to the same
[FQDN](http://en.wikipedia.org/wiki/Fully_qualified_domain_name), you
should avoid this when possible. If necesseray you can use a model
called [Comet](http://en.wikipedia.org/wiki/Comet_(programming)).  
- Security: Security is hard. Beware of
[XSS](http://en.wikipedia.org/wiki/Cross-site_scripting),
[CSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery) and [SQL
injection](http://en.wikipedia.org/wiki/SQL_injection).  
  
<span style="font-weight:bold;">What you as an ASP.NET Developer, need
to know about jQuery.</span>  
  
This session was hosted by [Gill Cleeren](http://www.snowball.be/). Gill
maintained a solid pace, and was able to show us a ton of code examples
in only 60 minutes.  
  
You can already [download the presentation and
samples](http://www.snowball.be/2010/11/11/Slides+And+Demos+From+My+Very+First+TechEd+Talk.aspx)
on his blog. Strongly adviced!  
  
<span style="font-weight:bold;">Best practices for building high
performance web applications</span>  
  
The host of this session was [Pete Lepage](petelepage.com). To be honest
I expected more from this session. Pete spent 75% of this session
advertising [IE9](beautyoftheweb.com)..  
  
I found a few useful best practices in this session though:  
- Javascript: Try to minimize [symbol
resolution](http://docs.sun.com/app/docs/doc/819-0690/chapter2-93321?a=view)
and remove duplicate scripts.  
- Network:
[Minify](http://jclaes.blogspot.com/2010/01/introduction-to-aspnet-ajax-4-minifier.html)
your scripts and use [sprites for
images](http://css-tricks.com/css-sprites/) to reduce network
connections.  
  
For more information on the subject, read [this
article](http://developer.yahoo.com/performance/rules.html) titled "Best
Practices for Speeding Up Your Web Site".  
  
<span style="font-weight:bold;">Data Development GPS: Guidance for
choosing the right data access technology for your application
today</span>  
  
[Drew Robbins](http://geekswithblogs.net/drewby/Default.aspx) took us
around all data access technologies available in .NET today.  
  
The most relevant data access technologies in .NET available today
are:  
- [ADO.NET Core](http://msdn.microsoft.com/en-us/data/aa937722.aspx)  
- [Linq To Sql](http://msdn.microsoft.com/en-us/library/bb425822.aspx)  
- [ADO.NET Entity
Framework](http://msdn.microsoft.com/en-us/library/aa697427(VS.80).aspx)  
- [WCF Data Services and
OData](http://msdn.microsoft.com/en-us/data/odata.aspx)  
  
ADO.NET Core isn't going anywhere. This is the foundation of all modern
.NET data access technologies. Use the ADO.NET Core when you want full
control. Linq To Sql still is fully supported, but little to none new
investments are made by Microsoft. You should avoid using Linq To Sql
for new projects. The technology you should use is the ADO.NET Entity
Framework. Microsoft is making signifcant investments into this
framework, and the .NET community seems to be very happy with this. WCF
Data Services and OData should be used for services that primarily
expose data.  
  
  
<span style="font-style:italic;">I plan on posting the most interesting
stuff here daily this week, so stay tuned!</span>
