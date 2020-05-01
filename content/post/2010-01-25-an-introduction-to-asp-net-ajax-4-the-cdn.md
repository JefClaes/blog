+++
title = "An introduction to ASP.NET Ajax 4: The CDN"
slug = "2010-01-25-an-introduction-to-asp-net-ajax-4-the-cdn"
published = 2010-01-25T08:00:00+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "AJAX",]
+++
Microsoft is providing a free content delivery network hosting ASP.NET
Ajax and jQuery. Next to these scripts, they are also hosting some
stylesheets which play together nicely with the Client Controls.  
  
<span style="font-weight:bold;">Define</span>  
  
Here is a definition I found on
[Wikipedia](http://en.wikipedia.org/wiki/Content_delivery_network).  

> A content delivery network is a system of computers containing copies
> of data, placed at various points in a network so as to maximize
> bandwidth for access to the data from clients throughout the network.
> A client accesses a copy of the data near to the client, as opposed to
> all clients accessing the same central server so as to avoid
> bottleneck near that server.

  
<span style="font-weight:bold;">Improving performance</span>  
  
Using the CDN will improve the performance of your webapplication in
several ways:

-   The number of networkhops gets reduced.
-   Browsers can reuse cached JavaScript files for webapplications that
    are located in different domains.
-   The load on your own webserver gets smaller.

  
<span style="font-weight:bold;">How to use</span>  
  
If you use the Scriptloader you only need to reference to one script on
the CDN. It will automatically download the other scripts from the
CDN.  

  

       1:  <script type="text/javascript" src="http://ajax.microsoft.com/ajax/beta/0911/Start.debug.js"></script>  

  

Click [here](http://www.asp.net/ajaxlibrary/CDN.ashx) for the [full CDN
directory listing](http://www.asp.net/ajaxlibrary/CDN.ashx).  
  
<span style="font-weight:bold;">More facts and pretty graphs</span>  
  
As I mentioned in
[this](http://jclaes.blogspot.com/2010/01/collection-of-useful-aspnet-ajax-40.html)
post, [this free
e-book](http://www.scribd.com/suggested_users?from=download&next_url=http://www.scribd.com/document_downloads/22677923%3Fextension%3Dpdf%26skip_interstitial%3Dtrue)
shows you how ASP.NET Ajax 4 can make your webapplications faster.
There's a whole chapter on the CDN in there.
