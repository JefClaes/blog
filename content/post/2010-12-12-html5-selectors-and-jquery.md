+++
title = "HTML5 selectors and jQuery"
slug = "2010-12-12-html5-selectors-and-jquery"
published = 2010-12-12T13:09:00.011000+01:00
author = "Jef Claes"
tags = [ "javascript", "Browsers", "jQuery",]
+++
In [my first post on the HTML5 javascript Selector
API](http://jclaes.blogspot.com/2010/11/html5-new-in-javascript-selector-api.html)
I wondered how the new methods querySelector() and querySelectorAll()
would influence [jQuery](http://jquery.com/).  
  
At the time, I couldn't find any information on the subject, but
yesterday I found out that jQuery has been taking advantage of these new
methods since version 1.4.3.  
  
From the [release
notes](http://blog.jquery.com/2010/10/16/jquery-143-released/)..  

> The performance of nearly all the major traversal methods has been
> drastically improved. .closest(), .filter() (and as a result, .is()),
> and .find() have all been greatly improved.  
>   
> These improvements were largely the result of making greater use of
> the browsers querySelectorAll and matchesSelector methods (should they
> exist). The jQuery project petitioned the browsers to add the new
> matchesSelector method (writing up a test suite, talking with vendors,
> and filing bugs) and the whole community gets to reap the excellent
> performance benefits now.  
>   
> [![](/post/images/thumbnails/2010-12-12-html5-selectors-and-jquery-jqueryClosestResults.jpg)](/post/images/2010-12-12-html5-selectors-and-jquery-jqueryClosestResults.jpg)  
> [![](/post/images/thumbnails/2010-12-12-html5-selectors-and-jquery-jQueryFilterResult.jpg)](/post/images/2010-12-12-html5-selectors-and-jquery-jQueryFilterResult.jpg)  
> [![](/post/images/thumbnails/2010-12-12-html5-selectors-and-jquery-jqueryFindResults.jpg)](/post/images/2010-12-12-html5-selectors-and-jquery-jqueryFindResults.jpg)  
> The above performance results specifically look at three very common
> cases in jQuery code: Using .closest() on a single DOM node, using
> .filter() (or .is()) on a single DOM node, and using .find() rooted on
> a DOM element (e.g. $(“\#test”).find(“something”)).  
>   
> Note that the the browsers shown are those that actually support
> querySelectorAll or matchesSelector – existing browsers that don’t
> support those methods continue to have the same performance
> characteristics.  

  
Looks like it's not a bad idea to keep an eye on the release notes..
