+++
title = "Internet Explorer, how could you miss this?"
slug = "2011-07-17-internet-explorer-how-could-you-miss-this"
published = 2011-07-17T15:30:00+02:00
author = "Jef Claes"
tags = [ "Browsers",]
+++
Modern browsers keep making efforts to make the web a better place. One
of those small, but so thoughtful features, is a way to tame unwanted
dialogs.  
  
If I run following JavaScript, Chrome and Firefox both help me disabling
it.  
  

    for (var i = 0; i < 1000; i++) {

        alert("Annoying alert " + i);

    }

  
[![](../images/thumbnails/2011-07-17-internet-explorer-how-could-you-miss-this-ChromeAnnoying.PNG)](../images/2011-07-17-internet-explorer-how-could-you-miss-this-ChromeAnnoying.PNG)[![](../images/thumbnails/2011-07-17-internet-explorer-how-could-you-miss-this-FirefoxAnnoying.PNG)](../images/2011-07-17-internet-explorer-how-could-you-miss-this-FirefoxAnnoying.PNG)  
Internet Explorer does not. Even if I kill the process of the tab, the
tab will try to restore itself, forcing me to kill Internet Explorer as
a whole.  
  
[![](../images/thumbnails/2011-07-17-internet-explorer-how-could-you-miss-this-IEAnnoyingKill.PNG)](../images/2011-07-17-internet-explorer-how-could-you-miss-this-IEAnnoyingKill.PNG)  
IE team, [I don't dislike your
browser](http://jclaes.blogspot.com/2011/03/how-will-ie9-maintain-momentum.html),
but this might be something worth implementing in IE10?
