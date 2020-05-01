+++
title = "Webforms lessons learned the hard way (Part 2)"
slug = "2010-02-15-webforms-lessons-learned-the-hard-way-part-2"
published = 2010-02-15T17:43:00+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "Best Practices",]
+++
If you missed part 1, you can find it
[here](http://jclaes.blogspot.com/2010/02/webforms-lessons-learned-hard-way-part.html).  
  
<span style="font-weight:bold;">Use the built-in goodies</span>  
  
ASP.NET Webforms has a lot of good stuff built into it. Do your homework
before you start building the next big Webforms thing! A perfect example
of this is ASP.NET Membership. ASP.NET provides an out-of-box membership
solution. I've seen people who were to lazy to do some research or
thought they could do better and ended up with a solution which put its
doors wide open to people with bad intentions.  
  
When a feature doesn't exactly match your needs, try extending it. The
ASP.NET team are artists as it comes to writing solid extensible
frameworks. I'd like to point to ASP.NET Membership again. You can write
your [own
provider](http://www.asp.net/(S(ywiyuluxr3qb2dfva1z5lgeg))/learn/videos/video-189.aspx),
which integrates with ASP.NET seamlessly.  
  
<span style="font-weight:bold;">Move as much as possible away from your
page</span>  
  
Separating the businesslogic and data-accesslogic from your
presentationlogic positively affects the quality of your page and
code-behind in so many ways.  
  
One of the big drawbacks of Webforms is that testing your pages isn't
easy. That's why it's important to keep the quantity of code in the
code-behind as low as possible. Code outside your presentationlogic can
easily be covered using unittests.  
  
Dividing your webapplication in multiple layers also makes the code in
the page and page-behind easier to grasp (encapsulation etc..).  
  
<span style="font-weight:bold;">Let others do it for you</span>  
  
Because most of the ASP.NET Server controls are easy to extend, there a
lot of third party control vendors out there.  
  
I've only been using the [Telerik
RadControls](http://www.telerik.com/products/aspnet-ajax.aspx) for a few
months now, and using this control suite, made my life so much easier.
1000$ might look like a big investment, but you can't believe how many
time it has saved me. Especially the
[RadGrid](http://demos.telerik.com/aspnet-ajax/grid/examples/performance/linq/defaultcs.aspx)
control is a great time-saver. Binding a list of objects to a RadGrid,
and finding out sorting, paging,.. just works is awesome.  
  
What are some of your Webforms lessons learned the hard way?
