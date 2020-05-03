+++
title = "HTML5 Offline Web applications as an afterthought in ASP.NET MVC"
slug = "2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc"
published = 2012-03-14T15:39:00+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2012/03/html5-offline-web-applications-as.html"
+++
Recently I prototyped a mobile web application using ASP.NET MVC,
[jQuery Mobile](http://jquerymobile.com/) and some HTML5 features. One
of the key goals was to find out how far you can push a web
'application' until the browser starts getting in the way. Working
disconnected is one of these things that appear to be a major
showstopper at first.  
  
However - to my surprise honestly - the [HTML5 Offline Web applications
API](http://dev.w3.org/html5/spec/offline.html) seems to be [widely
implemented](http://caniuse.com/#search=offline) across modern browsers
already. [Not of all of them
though](https://picasaweb.google.com/lh/photo/lVnWvGLepGsFhIc2Z4SKdcdrvCRMWyke7-RbgGXMEiI?feat=directlink).
Looking into the specifics, the API itself is fairly straightforward. At
his core, you will find the manifest file, which dictates which files
should be cached by the browser. The API provides other useful events
and methods for inspecting the status of the cache and swapping the
cache for a newer version, but they are out of scope today. A useful
resource to read up on the full API can be found
[here](http://dev.opera.com/articles/view/offline-applications-html5-appcache/),
and a working example implementation can be found
[here](http://html5demos.com/offlineapp).  
  
### The manifest file  
  
Back to the manifest file. A manifest file could look like this.  
  

[![](/post/images/thumbnails/2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc-ManifestFile.PNG)](/post/images/2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc-ManifestFile.PNG)

  

The first line in the file should say `CACHE MANIFEST`. If you want to
write comments, you should prefix the lines with a number sign.  
  
In the `CACHE` section you declare which files should be cached. An
important and interesting note is that these files will be served from
the cache, even if you're online.  
  
In the `NETWORK` section you declare which files the browser should try to
download from the server, regardless of whether the user is online or
offline.  
  
In the last section, the `FALLBACK` section, you can define fallback
resources to be used when the user is offline.  
  
### Serving and generating the manifest file 
  
Now that we got all this theory out of the way, let's look at generating
and serving the manifest file using ASP.NET MVC.  
  
I started by adding a ResourcesController with one action named
Manifest.  

```csharp
public class ResourcesController : Controller
{             
    public ActionResult Manifest() { }
}
```

This action should serve a text file, using a specific cache-manifest
MIME type. To accommodate this I created a new action result, which
inherits from the [FileResult](http://msdn.microsoft.com/en-us/library/system.web.mvc.fileresult.aspx) class, and overwrites the content type.  

```csharp
public class ManifestResult : FileResult
{
    public ManifestResult(string version)
        : base("text/cache-manifest") { }    
}
```

I also made this same class (for the sake of example) responsible for
formatting and writing the manifest file to the output stream. That's
why I added a few extra properties to the manifest result, one for each
section and one for versioning. Versioning the file comes in handy when
you want to expire the cache, because it only expires when the manifest
file changes.  

```csharp
public class ManifestResult : FileResult
{
    public ManifestResult(string version)
        : base("text/cache-manifest")
    {
        CacheResources = new List<string>();
        NetworkResources = new List<string>();
        FallbackResources = new Dictionary<string, string>();
        Version = version;
    }

    public string Version { get; set; }
    public IEnumerable<string> CacheResources { get; set; }
    public IEnumerable<string> NetworkResources { get; set; }       
    public Dictionary<string, string> FallbackResources { get; set; }        
}

To write the file to the output stream, I had to override the `WriteFile`
method.  

```csharp
protected override void WriteFile(HttpResponseBase response)
{
    WriteManifestHeader(response);            
    WriteCacheResources(response);
    WriteNetwork(response);
    WriteFallback(response);
}

private void WriteManifestHeader(HttpResponseBase response)
{
    response.Output.WriteLine("CACHE MANIFEST");
    response.Output.WriteLine("#V" + Version ?? string.Empty);            
}

private void WriteCacheResources(HttpResponseBase response)
{
    response.Output.WriteLine("CACHE:");           
    foreach (var cacheResource in CacheResources)
        response.Output.WriteLine(cacheResource);
}

private void WriteNetwork(HttpResponseBase response)
{
    response.Output.WriteLine();
    response.Output.WriteLine("NETWORK:");            
    foreach (var networkResource in NetworkResources)
        response.Output.WriteLine(networkResource);
}

private void WriteFallback(HttpResponseBase response)
{
    response.Output.WriteLine();
    response.Output.WriteLine("FALLBACK:");
    foreach (var fallbackResource in FallbackResources)
        response.Output.WriteLine(fallbackResource.Key + " " + fallbackResource.Value);
}
```

In the `CACHE` section I wanted to include all my static resources,
meaning the contents of the Scripts and Content folder. To do this in a
simple and low-maintenance fashion I introduced the
`GetRelativePathsToRoot` method. This method takes the path of a virtual
folder, recursively scans its content and returns a list of relative
paths for each file.  

```csharp
private IEnumerable<string> GetRelativePathsToRoot(string virtualPath)
{
    var physicalPath = Server.MapPath(virtualPath);
    var absolutePaths = Directory.GetFiles(physicalPath, "*.*",   SearchOption.AllDirectories);

    return absolutePaths.Select(
        x => Url.Content(virtualPath + x.Replace(physicalPath, ""))
    );
}
```

For the Content folder, the result could look something like this.  
  

[![](/post/images/thumbnails/2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc-ContentFolder.png)](/post/images/2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc-ContentFolder.png)

To add pages to the `CACHE` section, I used the Url.Action method.  
  
For the `NETWORK` resources, I added an asterisk, which basically means
that the cache shouldn't be used when the user is online. I didn't
specify any fallback resources in this example.  

```csharp
public ActionResult Manifest()
{
    var pages = new List<string>();
    pages.Add(Url.Action("SomeAction", "ControllerName"));    

    var scriptsPaths = GetRelativePathsToRoot("~/Scripts/");
    var contentPaths = GetRelativePathsToRoot("~/Content/");

    var cacheResources = new List<string>();
    cacheResources.AddRange(pages);
    cacheResources.AddRange(contentPaths);
    cacheResources.AddRange(scriptsPaths);
    
    var manifestResult = new ManifestResult("1.0")
    {
        NetworkResources = new string[] { "*" },
        CacheResources = cacheResources
    };            

    return manifestResult;
}
```

### Setting up a route and including the manifest  
  
Now that we are able to generate and serve a manifest file, we should
set up a specific route for the manifest file; some browsers aren't very
forgiving and expect it to have a specific name and location:
/cache.manifest.  

```csharp
routes.MapRoute("cache.manifest", "cache.manifest", new { controller = "Resources", action = "Manifest" });
```

The last step I had to take was include a reference to the manifest file
in the html element.  

```html
<html manifest="@Url.RouteUrl("cache.manifest")")/>
```

### Poor man's testing  
  
To verify if all of this works, you can look at the console of the
Chrome developer tools. You should see something like this.  
  
[![](/post/images/thumbnails/2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc-ManifestDownloading.PNG)](/post/images/2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc-ManifestDownloading.PNG)

That console logging has proven to be extremely useful when debugging
the manifest file.  
  
You could also just browse to the manifest file to inspect its content.
Don't mind this screenshot too much, obviously there's plenty of
cleaning up to do in my Scripts folder.  
  

[![](/post/images/thumbnails/2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc-BrowsetoManifestFile.PNG)](/post/images/2012-03-14-html5-offline-web-applications-as-an-afterthought-in-asp-net-mvc-BrowsetoManifestFile.PNG)

  
### Summary  
  
In this post I showed you a technique I came up with to take advantage
of ASP.NET MVC to easily generate, maintain and serve an HTML5 Offline
Webappliction manifest file:  

- Create a controller and action that can serve the file
- Create a new action result, which returns the correct MIME type and formats the file
- Set up a specific route
- Include a reference to the manifest in the html tag

Remember, this is a proof of concept, it's not perfect. I look forward
to any feedback you might have!
