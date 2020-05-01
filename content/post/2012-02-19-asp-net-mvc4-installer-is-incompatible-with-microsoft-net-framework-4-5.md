+++
title = "ASP.NET MVC4 Installer is incompatible with Microsoft .NET Framework 4.5"
slug = "2012-02-19-asp-net-mvc4-installer-is-incompatible-with-microsoft-net-framework-4-5"
published = 2012-02-19T16:52:00+01:00
author = "Jef Claes"
tags = [ "MVC", "ASP.NET MVC", "ASP.NET",]
+++
I tried installing [ASP.NET MVC4 beta](http://www.asp.net/mvc/mvc4)
today, but seconds into the installation the WebPI already halted the
process.  

> ASP.NET MVC4 Installer is incompatible with Microsoft .NET Framework
> 4.5

Apparently, this was documented in the ASP.NET MVC4 [installation
notes](http://www.asp.net/whitepapers/mvc4-release-notes#_Toc303253802).  

> This release is not compatible with the .NET Framework 4.5 Developer
> Preview. You must uninstall the .NET 4.5 Developer Preview before
> installing the ASP.NET MVC 4 Beta.

I guess you have to be forgiving if you want to play with the early
bits.  
  
Make sure to uninstall **all** the .NET Framework 4.5 related stuff
though. I had some pain, wasting over an hour, after only partially
removing the installation.  
  

[![](../images/thumbnails/2012-02-19-asp-net-mvc4-installer-is-incompatible-with-microsoft-net-framework-4-5-uninstall.PNG)](../images/2012-02-19-asp-net-mvc4-installer-is-incompatible-with-microsoft-net-framework-4-5-uninstall.PNG)

  
**Update:** [Brad Wilson answers the question why they aren't
compatible.](https://twitter.com/#!/bradwilson/status/170237822647808000)  
**Update:** [Scott Guthrie announced that the next Beta release should
be
compatible.](http://weblogs.asp.net/scottgu/archive/2012/02/19/asp-net-mvc-4-beta.aspx)
