+++
title = "Response.RedirectPermanent in .NET 3.5 and older"
slug = "2009-12-05-response-redirectpermanent-in-net-3-5-and-older"
published = 2009-12-05T17:50:00.004000+01:00
author = "Jef Claes"
tags = [ ".NET", "ASP.NET", "Browsers",]
+++
One of the new features in ASP.NET 4.0 is permanently redirecting to a
page using
[Response.RedirectPermanent](http://msdn.microsoft.com/en-us/library/system.web.httpresponse.redirectpermanent(VS.100).aspx).  

> It is common practice in Web applications to move pages and other
> content around over time, which can lead to an accumulation of stale
> links in search engines. In ASP.NET, developers have traditionally
> handled requests to old URLs by using by using the Response.Redirect
> method to forward a request to the new URL. However, the Redirect
> method issues an HTTP 302 Found (temporary redirect) response, which
> results in an extra HTTP round trip when users attempt to access the
> old URLs.  
> [Source](http://www.asp.net/LEARN/whitepapers/aspnet4/default.aspx#_TOC1_4)

You can achieve this functionality in ASP.NET 3.5 and older by writing a
<span style="font-weight: bold;">301 Moved Permanently Status</span> and
a <span style="font-weight: bold;">Location Header</span> to the
Response stream. This can be found in the [HTTP
specifications](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html).  
  
Here is an example.  

  

       1:  Response.Clear();

       2:  Response.Status = "301 Moved Permanently";

       3:  Response.AddHeader("Location", "PageOne.aspx");

       4:  Response.End();

  

You can verify this by using
[Fiddler](http://www.fiddler2.com/fiddler2/).  
  
[![](/post/images/thumbnails/2009-12-05-response-redirectpermanent-in-net-3-5-and-older-fiddler.JPG)](/post/images/2009-12-05-response-redirectpermanent-in-net-3-5-and-older-fiddler.JPG)
