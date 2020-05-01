+++
title = "Programming for the future of mobile"
slug = "2011-11-09-programming-for-the-future-of-mobile"
published = 2011-11-09T22:27:00+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "javascript", "Ramblings", "jQuery",]
+++
I have been working on something small on the side lately. I hardly have
anything to show for it though, most of it is still being shaped in my
head.  
  
Anyhow, a very important part of the front-end is built using [jQuery
mobile](http://jquerymobile.com/). Although the framework hasn't been
released - release candidates are available though -, it's something you
should start looking into today. Why? Because the browser is the future
of mobile applications. With the
[Flash](http://blogs.adobe.com/conversations/2011/11/flash-focus.html)
and [Silverlight
bombs](http://www.theverge.com/2011/11/9/2548975/microsoft-may-halt-development-work-on-silverlight-after-next-release)
that were dropped today, I am even more confident that that future might
be nearer than we think.  
  
Built upon the jQuery and jQuery UI foundation, jQuery mobile aims to
make mobile web applications seriously cross-platform and cross-device,
while optimizing for touchfriendliness. From what I've seen so far, the
jQuery team has (once again) succeeded at making the web just work.  

  

To start using jQuery mobile, you just have to add one extra script file
and one stylesheet on top of the existing jQuery infrastructure. Once
that is done, the framework will already do most of the heavy lifting
for you. Depending on your needs, you might want to enrich some elements
explicitly in a nice semantic fashion.  
  
For example, this is how you would get some collapsible panel action
going.  

    <div data-role="collapsible" data-theme="c" data-content-theme="c" data-collapsed="@dataCollapsed" id="entriesList">
        <h3>@entryGroup.Date.ToString("dd/MM/yyyy")</h3>                        
      
        <ul data-role="listview" data-inset="true" data-theme="d">        
            @foreach (var entry in entryGroup.Entries)
            {           
                <li>
                    @entry.CreatedOn.ToString("HH:mm") @entry.Description                     
                </li>         
            }
        </ul>
    </div>  

To give you an idea, this would result in something that looks like
this. Clean, right?  
  

[![](/post/images/thumbnails/2011-11-09-programming-for-the-future-of-mobile-jQueryMobile.PNG)](/post/images/2011-11-09-programming-for-the-future-of-mobile-jQueryMobile.PNG)

  
Now that these problems are out of the way soon, the only barrier left
for mobile web applications is that the browser has no actual hooks in
the device itself. But this last barrier can't hold forever... Mozilla
initiated a very interesting project not so long ago. They started
defining standards for a set of APIs that should give you direct access
to the device: a camera API, telephony and messaging API, accelerometer
API.. Find everything about the WebAPI initiative
[here](https://wiki.mozilla.org/WebAPI). Subscribe to the [mailing
list](https://lists.mozilla.org/listinfo/dev-webapi), participate and
help pushing the web forward.  
  
I'm fairly optimistic about the future of mobile web applications. It's
impossible to put a timeframe on it, **but eventually WWW, the Web Will
Win.**
