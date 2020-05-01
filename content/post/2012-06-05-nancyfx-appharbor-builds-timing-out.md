+++
title = "NancyFx Appharbor builds timing out"
slug = "2012-06-05-nancyfx-appharbor-builds-timing-out"
published = 2012-06-05T21:26:00.001000+02:00
author = "Jef Claes"
tags = [ "ASP.NET MVC", "ASP.NET",]
+++
I have been working on a petite portfolio site for my girlfriend which
is implemented in [NancyFx](http://nancyfx.org/), hosted in ASP.NET. On
deploying the project to [Appharbor](https://appharbor.com/), my builds
kept timing out. Since the build log was empty, I turned to Twitter for
help. [This fine gentleman](http://twitter.com/csainty) provided me with
a solution.  
  
When you add the Razor view engine to your project using the [Nuget
package](http://nuget.org/packages/Nancy.Viewengines.Razor), the
postbuild event of your project will be modified to xcopy some
assemblies into the bin - which apparently is an Intellisense and
precompilation thing.  
  
You do not want to do this in production. Open your project file (or
project properties), and change the postbuild event to include a
configuration condition.  

    <PropertyGroup>
        <PostBuildEvent>
          if $(ConfigurationName) == Debug (
            xcopy /s /y "$(SolutionDir)packages\Nancy.Viewengines.Razor.0.11.0\BuildProviders\Nancy.ViewEngines.Razor.BuildProviders.dll" "$(ProjectDir)bin"
            xcopy /s /y "$(SolutionDir)packages\Nancy.Viewengines.Razor.0.11.0\lib\Net40\Nancy.ViewEngines.Razor.dll" "$(ProjectDir)bin"
          )
        </PostBuildEvent>
    </PropertyGroup>

I have it on good authority that this will be fixed in the next package.
