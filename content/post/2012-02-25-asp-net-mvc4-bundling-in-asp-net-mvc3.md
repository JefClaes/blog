+++
title = "ASP.NET MVC4 bundling in ASP.NET MVC3"
slug = "2012-02-25-asp-net-mvc4-bundling-in-asp-net-mvc3"
published = 2012-02-25T20:26:00+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2012/02/aspnet-mvc4-bundling-in-aspnet-mvc3.html"
+++
One of the new wildly evangelized features of [ASP.NET MVC4](http://www.asp.net/mvc/mvc4) is the [built-in support for bundling and minification](http://weblogs.asp.net/scottgu/archive/2011/11/27/new-bundling-and-minification-support-asp-net-4-5-series.aspx) of scripts and stylesheets.  
  
I don't see any reason why this new feature wouldn't work for ASP.NET
MVC3 though. If you open the packages config of an ASP.NET MVC4 beta
project, you will find that bundling support lives in the
`Microsoft.Web.Optimization` package.  

```xml
<package id="Microsoft.Web.Optimization" version="1.0.0-beta" />
```

So we should just be able to install [this package](http://nuget.org/packages/Microsoft.Web.Optimization/0.1) for
an ASP.NET MVC3 project. To install the package, run following command. Pay attention to the `-Pre` switch.  

```
PM> Install-Package Microsoft.Web.Optimization -Pre
Attempting to resolve dependency 'Microsoft.Web.Infrastructure (= 1.0.0)'.
Successfully installed 'Microsoft.Web.Infrastructure 1.0.0.0'.
Successfully installed 'Microsoft.Web.Optimization 1.0.0-beta'.
Successfully added 'Microsoft.Web.Infrastructure 1.0.0.0' to Optimization.
Successfully added 'Microsoft.Web.Optimization 1.0.0-beta' to Optimization.
```

Adding bundles happens when the application starts, together with
registering areas, adding global filters and registering routes.  
  
The quickest way to enable bundling is by enabling the default
bundles.  

```csharp
BundleTable.Bundles.EnableDefaultBundles();
```

This method will add two bundles to the bundle table: one bundle for the
stylesheets in the Content folder and one bundle for the scripts in the
Scripts folder. The default bundles try to take core scripts into
account when ordering the scripts in the bundle. For example, jQuery
will be included before any of its plug-ins are included.  
  
To reference these bundles you can add following snippet to your view or
layout file.  

```html
<link href="@System.Web.Optimization.BundleTable.Bundles.ResolveBundleUrl("~/Content/css")" 
    rel="stylesheet" type="text/css" />
<script src="@System.Web.Optimization.BundleTable.Bundles.ResolveBundleUrl("~/Scripts/js")">
</script>    
```

If you start your application now, and inspect the HTML, you will find
two versioned links to a minified version of your CSS and JavaScript.  
  

[![](/post/images/thumbnails/2012-02-25-asp-net-mvc4-bundling-in-asp-net-mvc3-minifiedhead.PNG)](/post/images/2012-02-25-asp-net-mvc4-bundling-in-asp-net-mvc3-minifiedhead.PNG)

[![](/post/images/thumbnails/2012-02-25-asp-net-mvc4-bundling-in-asp-net-mvc3-minifiedJS.PNG)](/post/images/2012-02-25-asp-net-mvc4-bundling-in-asp-net-mvc3-minifiedJS.PNG)

If you're trying this on a new project, you will probably have no
problems. However, if you're trying this on an existing project, chances
are that some things are not included how they should be.  
  
To troubleshoot what's going wrong, you can inspect the results of the
`GetRegisteredBundles` method.

```csharp
var registeredBundles = BundleTable.Bundles.GetRegisteredBundles();
```

If you need more fine-grained control, you can remove the default bundles again and add your own bundles to the bundle table.  
  
For example, this is how you can add a jQuery bundle.  

```csharp
var jQueryBundle = new Bundle("~/Scripts/jquery", new JsMinify());
jQueryBundle.AddDirectory("~/Scripts", "jquery*.js", searchSubdirectories: false, throwIfNotExist: true);

BundleTable.Bundles.Add(jQueryBundle);
```

```html
<script src="@System.Web.Optimization.BundleTable.Bundles.ResolveBundleUrl("~/Scripts/jQuery")">
</script>  
```

When you instantiate a new bundle, specify the relative path of the
bundle and pick a bundle transformation. You can add a directory to the
bundle, filtered by a search pattern. You can also tell the algorithm to
search in the subdirectories or to throw an exception when the directory
doesn't exist.  
  
If you don't want to add a whole directory to the bundle, but just one
or more files, you can use the `AddFile` method.  
  
For example, this is a separate bundle for modernizr.  

```csharp
var modernizrBundle = new Bundle("~/Scripts/modernizr", new JsMinify());
modernizrBundle.AddFile("~/Scripts/modernizr-1.7.js", throwIfNotExist: true);

BundleTable.Bundles.Add(modernizrBundle);
```

### Conclusion
  
It's relatively easy to take advantage of bundling in ASP.NET MVC3.
Install the NuGet package, set up the bundle table, include the
references in your view or layout page and you're done.  
  
There are some more interesting things you can do using bundling. I just
started experimenting with it, so I wouldn't be surprised if I will be
writing a few more things on bundling in the coming weeks.