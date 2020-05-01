+++
title = "The state of the client-side ASP.NET Ajax 4.0 framework"
slug = "2010-04-19-the-state-of-the-client-side-asp-net-ajax-4-0-framework"
published = 2010-04-19T21:00:00.009000+02:00
author = "Jef Claes"
tags = [ "ASP.NET", "AJAX", "javascript", "jQuery",]
+++
The people who follow my blog might remember the [ASP.NET Ajax 4.0
series](http://jclaes.blogspot.com/2010/01/wrapping-up-an-introduction-to-aspnet.html).
In these series I showed some of the core features of the ASP.NET Ajax
4.0 beta javascript library.  
  
In January Microsoft told us that they would ship the ASP.NET Ajax 4.0
library as a part of the Microsoft Ajax framework, together with the
release of ASP.NET 4.0. A few days ago I was ready to dig in the library
a little deeper, but I found out that most of the documentation and
resources I used to consult, had moved or had disappeared.  
  
If you [follow me on Twitter](http://twitter.com/JefClaes) you might
have seen me ranting about this. [Lee
Dumond](http://twitter.com/LeeDumond) and [Stijn
Volders](http://twitter.com/one75) told me that the ASP.NET Ajax 4.0
library now is a part of the Ajax Controltoolkit and that it's
deprecated.  
  
I contacted Dave Reed
([InfinitiesLoop](http://weblogs.asp.net/infinitiesloop/)) for some more
clarity on this subject and he told me this:  

> The scripts aren't going away, but we aren't investing in them
> anymore, instead we are looking at how we can extend jQuery to meet
> the same needs. We are folding those scripts into the
> AjaxControlToolkit (on
> [ajaxcontroltoolkit.codeplex.com](http://ajaxcontroltoolkit.codeplex.com/)
> -- ajax.codeplex.com is no longer), so you can still get them from
> there, and even contribute to them if you would like.

  
Dave also pointed me to a [post on Stephen Walther's
blog](http://stephenwalther.com/blog/archive/2010/03/16/microsoft-jquery-and-templating.aspx),
where this part is interesting:  

> We are moving the ASP.NET Ajax Library into the Ajax Control Toolkit.
> If you currently use ASP.NET Ajax Library client templates, client
> data-binding, or the client script loader then you can continue to use
> these features by downloading the Ajax Control Toolkit.  
>   
> Be aware that our focus with the Ajax Control Toolkit is server-side
> Ajax. For client-side Ajax, we are shifting our focus to jQuery. For
> example, if you have been using ASP.NET Ajax Library client templates
> then we recommend that you shift to using jQuery instead.

  
<span style="font-weight:bold;">Conclusion</span>  
  
It's like the client-side ASP.NET Ajax framework is jinxed. Same as with
the previous releases of the client-side ASP.NET Ajax framework, this
release is dead before it got a chance to live. I definitely have
sympathy for Microsoft on this one though, jQuery really is that good. I
only hope that they will be able to push some of the best features of
the ASP.NET Ajax 4.0 library into jQuery.
