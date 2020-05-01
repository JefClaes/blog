+++
title = "Out with YSLOW, in with PageSpeed Insights"
slug = "2012-10-10-out-with-yslow-in-with-pagespeed-insights"
published = 2012-10-10T18:48:00+02:00
author = "Jef Claes"
tags = [ "Tools", "Browsers",]
+++
My alarm clock goes of at 6:20; my fingers are able to locate the snooze
button without me having to open my eyes. To my annoyance, the
aggravating noise of the alarm returns ten minutes later. I need to get
up this time. With nearly opened eyes, I glance at the time, and press
the dismiss button to silence the alarm for good.  
I open my eyes; light is already coming through the curtains; this
shouldn't be. My heart skips a beat; I'm wide awake, and look at the
clock in awe: 7:55. I overslept.  
  
I unplug my phone from the charger next to the bedside table, open the
browser, and navigate to [the national railway's
website.](http://www.belgianrail.be/nl/Home.aspx) The site seems to be
slow today, it took seconds to download the first page, and now the
screen stays blank, waiting for the rendering to finish. When the page
is finally drawn, I notice they deployed a new version overnight. On
each subsequent page visit, I'm annoyed. This shouldn't take this long;
I don't have time for this right now.  
  
Arriving at work, later than usual, I visited the site again using my
desktop. I'm always intrigued by slow websites, especially when built by
a big public company for a large audience. I see them as a cheap
opportunity to learn from their mistakes, so I don't have to make them
myself.  
  
By having a shallow look at the source and opening the network tab, I
can already spot a few things amiss: the browser needs to download
2,11MB from 80 different resources, ASP.NET Webforms, viewstate,
ridiculous id's, misplaced script tags, and non-bundled and non-minified
resources.  
  
To get an in-depth analysis, I always turned to
[YSLOW](http://developer.yahoo.com/yslow/), but I had been a bit
dissappointed by the amount of innovation there over the last few years.
An extra tool I used sporadically was [Google PageSpeed
online](https://developers.google.com/speed/pagespeed/insights), which I
found to report more granular results, and to also test for more recent
findings in web performance research. To my surprise, I discovered that
this tool is now also available as a Chrome plug-in, meaning I can also
use it for local sites.  
  
[![](/post/images/thumbnails/2012-10-10-out-with-yslow-in-with-pagespeed-insights-NMBSPageSpeedResults.PNG)](/post/images/2012-10-10-out-with-yslow-in-with-pagespeed-insights-NMBSPageSpeedResults.PNG)  
  
I'm not sure when this became available though. When I look at the
trend, it seems that PageSpeed Insights is rapidly becoming the new
favorite.  
  

[![](/post/images/thumbnails/2012-10-10-out-with-yslow-in-with-pagespeed-insights-yslowtrend.PNG)](/post/images/2012-10-10-out-with-yslow-in-with-pagespeed-insights-yslowtrend.PNG)

  
  
Even the Chrome webstore reports 177k users for the PageSpeed Insights
plug-in, while the YSLOW plug-in *only* has 159k.  
  

[![](/post/images/thumbnails/2012-10-10-out-with-yslow-in-with-pagespeed-insights-PageSpeedApp.PNG)](/post/images/2012-10-10-out-with-yslow-in-with-pagespeed-insights-PageSpeedApp.PNG)

  

[![](/post/images/thumbnails/2012-10-10-out-with-yslow-in-with-pagespeed-insights-YslowApp.PNG)](/post/images/2012-10-10-out-with-yslow-in-with-pagespeed-insights-YslowApp.PNG)

  
Maybe I'm preaching to the choir, but I hope to have introduced at least
one person to, what was for me, a new tool.
