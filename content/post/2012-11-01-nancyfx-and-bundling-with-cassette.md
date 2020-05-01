+++
title = "NancyFx and bundling with Cassette"
slug = "2012-11-01-nancyfx-and-bundling-with-cassette"
published = 2012-11-01T19:02:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "CSS", ".NET", "Browsers", "HTTP", "NancyFx", "Tips",]
+++
Working on a new side project built using
[NancyFx](http://nancyfx.org/), I wanted to bundle and minify my css and
script resources. Looking into the options,
[Cassette](http://getcassette.net/) (\*) seemed the most obvious
option.  
  
Since I struggled with the implementation a little bit, I documented the
process below.  
  
**1. Cassette.Nancy package**  
**  
**Add the [Cassette.Nancy
package](http://nuget.org/packages/Cassette.Nancy) to the project.  

    PM> Install-Package Cassette.Nancy
    Attempting to resolve dependency 'Cassette'.
    Attempting to resolve dependency 'AjaxMin (= 4.60)'.
    Attempting to resolve dependency 'Nancy'.
    Attempting to resolve dependency 'Nancy.ViewEngines.Razor'.
    Attempting to resolve dependency 'NLog'.
    Successfully installed 'AjaxMin 4.60.4609.17023'.
    Successfully installed 'Cassette 2.0.0'.
    Successfully installed 'NLog 2.0.0.2000'.
    Successfully installed 'Cassette.Nancy 2.0.0'.
    Successfully added 'AjaxMin 4.60.4609.17023' to Project.
    Successfully added 'Cassette 2.0.0' to Project.
    Successfully added 'NLog 2.0.0.2000' to Project.
    Successfully added 'Cassette.Nancy 2.0.0' to Project.

**2. Bundle configuration**  
**  
**The Nuget package adds the CassetteBundleConfiguration class to the
root of your project.  
  
I'm lucky to have my assets structured rather simply, which makes
[setting up the
bundles](http://getcassette.net/documentation/v2/bundle-configuration) take
little to no effort.  
  

[![](../images/thumbnails/2012-11-01-nancyfx-and-bundling-with-cassette-asset_structure.PNG)](../images/2012-11-01-nancyfx-and-bundling-with-cassette-asset_structure.PNG)

    public class CassetteBundleConfiguration : IConfiguration<BundleCollection>
    {
        public void Configure(BundleCollection bundles)
        {
            bundles.AddPerSubDirectory<StylesheetBundle>("Content");
            bundles.AddPerSubDirectory<ScriptBundle>("Content");
        }
    }

[Each
sub-directory](http://getcassette.net/documentation/v2/bundle-configuration/add-per-sub-directory)
now becomes a bundle.  
  
To arrange the files in the bundles, I added a bundle.txt file that
defines the order to each sub-directory. For the css sub-directory it
looks like this.  

    bootstrap.css
    bootstrap-responsive.css
    docs.css

**3. Using bundles**  
**  
**To use these bundles in my view, I first reference them, for then to
render them in their optimal location - css in the head section, and
scripts just before the closing body tag.  

    @using Cassette.Nancy

    @{
        Bundles.Reference("Content/css");
        Bundles.Reference("Content/scripts");
    }

    @Bundles.RenderStylesheets()
    @Bundles.RenderScripts()

**4. First try**  

  

When you now browse to your application, and view the source, you'll
notice that Cassette is already in play, yet the assets are not bundled
nor minified.  
  
[![](../images/thumbnails/2012-11-01-nancyfx-and-bundling-with-cassette-cassette_not_bundled.PNG)](../images/2012-11-01-nancyfx-and-bundling-with-cassette-cassette_not_bundled.PNG)  
  
**5. Enable optimization**  
  
Apparently when using NancyFx, you need to explicitly enable
optimization.  

> By default, the output from Cassette is not optimized. When output is
> optimized, Cassette modules are combined (bundled) based on the
> configuration and sent to the client as a single lump per bundle
> instead of lots of individual files.

When you're using ASP.NET MVC, this is dependant on the compilation
debug switch.  
  
The best place to enable this, is probably in your bootstrapper.  

    public class Bootstrapper : DefaultNancyBootstrapper
    {
        public Bootstrapper()
        {
            Cassette.Nancy.CassetteNancyStartup.OptimizeOutput = true;
        }
    }

**6. Second try**  
**  
**This time around, the assets do get bundled and minified.  
  

[![](../images/thumbnails/2012-11-01-nancyfx-and-bundling-with-cassette-cassette_bundled.PNG)](../images/2012-11-01-nancyfx-and-bundling-with-cassette-cassette_bundled.PNG)

  

[![](../images/thumbnails/2012-11-01-nancyfx-and-bundling-with-cassette-minified.PNG)](../images/2012-11-01-nancyfx-and-bundling-with-cassette-minified.PNG)

  
\* It wasn't until today that I noticed the asset in C**asset**te.
