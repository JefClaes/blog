+++
title = "Why the javascript beforeunload event is incomplete"
slug = "2009-09-12-why-the-javascript-beforeunload-event-is-incomplete"
published = 2009-09-12T21:13:00.010000+02:00
author = "Jef Claes"
tags = [ "ASP.NET", "javascript", "Browsers", "Ramblings",]
+++
The
[onbeforeunload](http://msdn.microsoft.com/en-us/library/ms536907(VS.85).aspx)
event fires when a page is being unloaded.  
  
In the intranet webapplications world customers pretty often ask to show
a warning when a user leaves a page (by closing the browser, closing a
tab, clicking a link,..). This feature is specifically very interesting
for data-input-driven webforms where one wrong click can make ten
minutes of work undone.  
  
Last week I had to [implement this
feature](http://forums.asp.net/t/1014977.aspx) in a huge webform which
is causing lots of postbacks (firing the onbeforeunload event). Actually
I only had to warn the user when they closed the browser or clicked a
link in the masterpage. I figured out that the beforeunload event must
have some convenient properties, but as you can see below, it had no
properties which I could use.  
  
[![](../images/thumbnails/2009-09-12-why-the-javascript-beforeunload-event-is-incomplete-eventprop.JPG)](../images/2009-09-12-why-the-javascript-beforeunload-event-is-incomplete-eventprop.JPG)  
  
Of course there are workarounds for this problem, like there are
workarounds for almost all technology problems. But these workarounds
often make tasks harder and less "clean".  
  
In my opinion the browsers could and should do something about this.
Adding a few properties like <span
style="font-style: italic;">unloadedbysrc, unloadedbytag,
unloadedbyid</span> would make our life a tad easier.  
  
<span style="font-weight: bold;">What do you think?</span>
