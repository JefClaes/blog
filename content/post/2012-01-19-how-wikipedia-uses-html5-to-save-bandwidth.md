+++
title = "How Wikipedia uses HTML5 to save bandwidth"
slug = "2012-01-19-how-wikipedia-uses-html5-to-save-bandwidth"
published = 2012-01-19T20:56:00+01:00
author = "Jef Claes"
tags = [ "Browsers", "HTML5",]
+++
Something I hadn't noticed until recently is that Wikipedia tries to use
the browser's native [SVG](http://www.w3.org/TR/SVG/) support to render
certain images. For example, if you search for [a high resolution image
of your country's
flag](http://upload.wikimedia.org/wikipedia/commons/9/92/Flag_of_Belgium_%28civil%29.svg),
you will probably end up viewing an SVG. Wikipedia also offers downloads
to the image rendered as a PNG though.  
  
Next to being able to scale to an arbitrary size without suffering data
loss, the SVG data format allows images to be far more compact.
Basically, SVG is just XML, which also means it can be easily compressed
to make its size even smaller. For example, this is the (uncompressed)
SVG for the flag of the [Kingdom of
Belgium](http://en.wikipedia.org/wiki/Belgium).  

    <svg xmlns="http://www.w3.org/2000/svg" width="450" height="300">
        <rect width="450" height="300"/>
        <rect x="150" width="150" height="300" fill="#FAE042"/>
        <rect x="300" width="150" height="300" fill="#ED2939"/>
    </svg>

This svg node only weighs as much as 224 bytes, while the image rendered
as a high resolution PNG weighs 13.402 bytes. Stuff like that makes a
significant difference when you're [serving millions of page views on a
daily
basis](http://stats.wikimedia.org/EN/TablesPageViewsMonthlyCombined.htm).  
  
The first time I touched SVG was a few years ago when I was still
working on fire department projects. We were working with a third party
that used SVG to draw maps in the browser. Being already in the
post-Google Maps era, I thought it was terrible I had to download
[Adobe's SVG viewer](http://www.adobe.com/svg/viewer/install/). While
the Google Maps technology already works great, there are still things
SVG can do better and cleaner, especially for more specialized GIS
applications. There is an interesting paper on that subject
[here](http://svgopen.org/2008/papers/82-Web_Mapping_and_WebGIS_do_we_actually_need_to_use_SVG/),
it's a bit outdated though.  
  
I can only applaud making the browser more capable, and losing *yet
another plug-in*. I'm curious to see how other applications will start
taking advantage of the opportunities native SVG support **across all
modern browsers** (even Internet Explorer) presents.  
  
Have you already built things using SVG? Or even considered it?
