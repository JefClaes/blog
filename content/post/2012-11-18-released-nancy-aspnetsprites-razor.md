+++
title = "Released: Nancy.AspNetSprites.Razor"
slug = "2012-11-18-released-nancy-aspnetsprites-razor"
published = 2012-11-18T15:06:00+01:00
author = "Jef Claes"
tags = [ "Tools", ".NET", "ASP.NET", "Browsers", "HTTP", "NancyFx", "Opensource",]
+++
I was setting up a web application that shows an image for each listed
product on the home page. When there were a few products, this worked
pretty smooth, but as the number of products (and thereby images)
increased, performance degraded. The problem is that each image
initiates a separate request. The solution for this problem is to reduce
the number of requests by combining the images using CSS sprites.
[Here](http://alistapart.com/articles/sprites) is an in-detail
explanation of how this works.  
  
I remembered the [Hanselman writing about a Nuget package which does all
the heavy lifting for
you](http://www.hanselman.com/blog/NuGetPackageOfTheWeek1ASPNETSpriteAndImageOptimization.aspx):
[Microsoft's ASP.NET Sprite and Image
Optimization](http://aspnet.codeplex.com/releases/view/65787).  

> The ASP.NET Sprite and Image Optimization framework is designed to
> decrease the amount of time required to request and display a page
> from a web server by performing a variety of optimizations on the
> page’s images. This is the fourth preview of the feature and works
> with ASP.NET Web Forms 4, ASP.NET MVC 3, and ASP.NET Web Pages (Razor)
> projects.

Installing that package, it dawned on me that I wasn't using Mvc, nor
WebForms, but Nancy on an ASP.NET host with the Razor view engine. So
out-of-the-box, this package couldn't work for me.  
  
I looked at the project a bit, and discovered that it would be easily
portable to Nancy (on an ASP.NET host with the Razor view engine). It
consists of three parts: AspNetSprites-Core,
AspNetSprites-WebFormsControl and AspNetSprites-MvcAndRazorHelper. I
could make use of the core package, and port the Mvc package to Nancy.
The port was pretty straightforward; I removed the Mvc dependencies, and
returned Nancy's IHtmlString instead of Mvc's IHtmlString. Note that
this all still heavily relies on ASP.NET and its infrastructure.  
  
I packaged this project for
[Nuget](http://nuget.org/packages/Nancy.AspNetSprites.Razor) yesterday,
and [the source is on
GitHub](https://github.com/JefClaes/Nancy.AspNetSprites.Razor) (under
the MIT license).  
  
Here is some documentation shaped as a how to.  
  
**Create an Empty ASP.NET Web Application**  
**  
**You can use the ASP.NET Empty Web Application template.  
  
**Install the package**

    PM; Install-Package Nancy.AspNetSprites.Razor
    Attempting to resolve dependency 'AspNetSprites-Core (= 0.4)'.
    Attempting to resolve dependency 'Nancy (= 0.13.0)'.
    Attempting to resolve dependency 'Nancy.Hosting.Aspnet (= 0.13.0)'.
    Attempting to resolve dependency 'Nancy.Viewengines.Razor (= 0.13.0)'.
    Successfully installed 'AspNetSprites-Core 0.4'.
    Successfully installed 'Nancy 0.13.0'.
    Successfully installed 'Nancy.Hosting.Aspnet 0.13.0'.
    Successfully installed 'Nancy.Viewengines.Razor 0.13.0'.
    Successfully installed 'Nancy.AspNetSprites.Razor 0.0.2'.
    Successfully added 'AspNetSprites-Core 0.4' to SpritesExample.
    Successfully added 'Nancy 0.13.0' to SpritesExample.
    Successfully added 'Nancy.Hosting.Aspnet 0.13.0' to SpritesExample.
    Successfully added 'Nancy.Viewengines.Razor 0.13.0' to SpritesExample.
    Successfully added 'Nancy.AspNetSprites.Razor 0.0.2' to SpritesExample.

This will add the references, alter the web.config, add an App\_Sprites
folder and add the necessary conventions automatically.  
  
**Known issue:** depending on the name of your assembly, the
AppSpritesConvention might be overwritten by one of Nancy's conventions.
While I'm trying to come up with a good solution, you can move the
convention to your bootstrapper.  
  

**Add images to the App\_Sprites folder**  
**  
**Add the images you want to make sprites for to the App\_Sprites
folder. You can also make use of subfolders. In this example I added two
images: image1.jpg and image2.jpg.  
  
**A working example**  
**  
**Add a simple Nancy module which returns a view named View.

    public class Module : NancyModule
    {
        public Module() 
        {
            Get["/"] = p => View["View"];
        }
    }

In your view, make use of the Sprite.ImportStyleSheet and the
Sprite.Image method to include the stylesheet and images.

    <!doctype html>
    <html>
        <head>   
            @Sprite.ImportStylesheet("~/App_Sprites")
        </head>
        <body>
        @Sprite.Image("~/App_Sprites/image1.jpg", new Dictionary<string, object>()
        {
            { "alt", "First image" }, 
            { "title","First image" }
        } )

        @Sprite.Image("~/App_Sprites/image2.jpg", new Dictionary<string, object>()
        {
            { "alt", "Second image" }, 
            { "title","Second image" }
        } )
    </body>

The outputted HTML and CSS now looks like this.  

    <!doctype html>
    <html>
    <head>   
        <link href="App_Sprites/highCompat.css" media="all" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <img alt="First image" class="image1.jpg" src="data:image/gif;base64,..." title="First image" />
        <img alt="Second image" class="image2.jpg" src="data:image/gif;base64,..." title="Second image" />
    </body>

    .image1\.jpg
    {
        width:468px;
        height:315px;
        background-image:url(sprite0.png);
        background-position:0px 0px;
    }
    .image2\.jpg
    {
        width:468px;
        height:315px;
        background-image:url(sprite0.png);
        background-position:-469px 0px;
    }

*I hope it will prove useful for someone in the future. Let me know if
you have any feedback or questions.*
