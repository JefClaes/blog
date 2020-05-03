+++
title = "How a web application can download and store over 2GB without you even knowing it"
slug = "2012-03-25-how-a-web-application-can-download-and-store-over-2gb-without-you-even-knowing-it"
published = 2012-03-25T13:11:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2012/03/how-web-application-can-download-and.html"
+++
I have been experimenting with the [HTML5 offline application
cache](http://www.w3.org/TR/html5/offline.html) some more over the last
few days, doing boundary tests in an attempt to learn more about browser
behaviour in edge cases.  
  
One of these experiments was testing the cache quota.  
  
Two weeks ago, I blogged about [generating and serving an offline
application manifest using ASP.NET MVC](http://jclaes.blogspot.com/2012/03/html5-offline-web-applications-as.html).

I reused that code to add hundreds of 7MB PDF files to the cache.  

```csharp
public ActionResult Manifest()
{     
    var cacheResources = new List<string>();
    var n = 300; // Play with this number

    for (var i = 0; i < n; i++)
        cacheResources.Add("Content/" + Url.Content("book.pdf?" + i));

    var manifestResult = new ManifestResult("1")
    {
        NetworkResources = new string[] { "*" },
        CacheResources = cacheResources
    };

    return manifestResult;
}
```

I initially tried adding 1000 PDF files to the cache, but this threw an
error: `Chrome failed to commit the new cache to the storage, because the
quota would be exceeded.`  
  
After lowering the number of files several times, I hit the sweet spot.
I could add 300 PDF files to the cache without breaking it.  

Looking into `chrome://appcache-internals/`, I can see the size of the
cache being a whopping **2.2GB** now for one single web application.

[![](/post/images/thumbnails/2012-03-25-how-a-web-application-can-download-and-store-over-2gb-without-you-even-knowing-it-appcache-internals.PNG)](/post/images/2012-03-25-how-a-web-application-can-download-and-store-over-2gb-without-you-even-knowing-it-appcache-internals.PNG)

As a user, I had no idea that the website I'm browsing is downloading a
suspicious amount of data in the background. Chrome (17.0.963.83), nor
any other desktop browser that I know of, warns me. I would expect the
browser to ask for my permission when a website wants to download and
store such an excessive amount of data on my machine.  
  
Something else I noticed, is that other sites now fail to commit
anything to the application cache due to the browser-wide quota being
exceeded. I'm pretty sure this 'first browsed, first reserved' approach
will be a source of frustration in the future.  
To handle this scenario we could use the applicationCache API to listen
for quota errors, and inform the user to browse to
`chrome://appcache-internals/` and remove other caches in favor of the
new one. This feels sketchy though; shouldn't the browser intervene in a
more elegant way here?  

[![](/post/images/thumbnails/2012-03-25-how-a-web-application-can-download-and-store-over-2gb-without-you-even-knowing-it-exceedquote.PNG)](/post/images/2012-03-25-how-a-web-application-can-download-and-store-over-2gb-without-you-even-knowing-it-exceedquote.PNG)
 
**What are your thoughts? What would you want your browser to do in
these scenarios?**
