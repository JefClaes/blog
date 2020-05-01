+++
title = "Released: Kill long meetings"
slug = "2012-11-25-released-kill-long-meetings"
published = 2012-11-25T17:45:00+01:00
author = "Jef Claes"
tags = [ "Tools", ".NET", "ASP.NET", "javascript", "NancyFx", "Opensource", "jQuery",]
+++
A lot has already been said and written about meetings, and some have
carried the message above par; ['Meetings: where work goes to
die](http://www.codinghorror.com/blog/2012/02/meetings-where-work-goes-to-die.html)'.
Today, I'm not going to foul the internet with another rant, but I'd
like to show you a small application built over the last few weeks after
work.  
  
I regularly find myself [building small
things](http://www.jefclaes.be/2011/09/building-small-things.html) as an
antitoxin to the regular periods of not writing and shipping code at
work. This time, me and [@cgeers](http://twitter.com/cgeers), built a
not-so-serious application that aims to kill long meetings by
visualizing the amount of time and money burned in a meeting.  
  

[![](../images/thumbnails/2012-11-25-released-kill-long-meetings-killlongmeetings.PNG)](../images/2012-11-25-released-kill-long-meetings-killlongmeetings.PNG)

While the application in itself probably will never attract a
sustainable user base, development sprouted two useful Twitter Bootstrap
plug-ins: [a spin edit
control](https://github.com/geersch/bootstrap-spinedit) and [a
multi-color
progressbar](https://github.com/geersch/bootstrap-progressbar).  
  
**Used technology stack **  
**  
**On the server, we're using [Nancy](http://nancyfx.org/) on an [ASP.NET
host](https://github.com/NancyFx/Nancy/wiki/Hosting-nancy-with-asp.net)
with Razor views. There is hardly anything going on at the server, so we
could have picked any server-side framework I guess. We might just be
attracted to the as 'little friction as possible' Nancy ethos though.
Returning a view, and setting up a route for it, takes just a few LOC.

    namespace KillLongMeetings
    {
        public class RootModule : NancyModule
        {
            public RootModule()
            {
                Get["/"] = p => View["HomeView"];
            }
        }
    }

Next to returning a correct view, we're also making bundles on the
server. For that, we're using [Cassette for
Nancy](http://www.jefclaes.be/2012/11/nancyfx-and-bundling-with-cassette.html).  
  
At the client, we chose to use [Twitter
Bootstrap](http://twitter.github.com/bootstrap/), because getting a
lay-out right that works everywhere these days is hard; we like to spend
that time on other things. Next to jQuery - duh, we're using
[knockout.js](http://knockoutjs.com/) as our client-side MVVM framework.
This worked out lovely for our scenario, but overall, I'm distancing
myself a bit from this framework. It's simple, and extremely easy to get
started with, but lots of companies I heard of seem to adapt this as an
application framework, which it is not. It's just two-way model binding
in the browser. More complex scenarios benefit from a cleaner separation
of concerns for validation, working with remote data, application
composition and testing. Right now, I'm doing something with
[angular.js](http://angularjs.org/), and it seems very promising so far.
It's also a lot less intrusive than knockout.js.  
  
We're using [AppHarbor](https://appharbor.com/) and GitHub for
continuous deployment. The production site however is a static site
hosted on [GitHub pages](http://pages.github.com/). Next to serving
everything really fast, we're now not paying for anything except the
domain name.  
  
**The source can be found on
[GitHub](https://github.com/JefClaes/KillLongMeetings). Let us know what
you think!**
