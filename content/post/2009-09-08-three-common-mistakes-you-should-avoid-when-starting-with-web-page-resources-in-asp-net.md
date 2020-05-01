+++
title = "Three common mistakes you should avoid when starting with Web Page Resources in ASP.NET"
slug = "2009-09-08-three-common-mistakes-you-should-avoid-when-starting-with-web-page-resources-in-asp-net"
published = 2009-09-08T20:04:00.006000+02:00
author = "Jef Claes"
tags = [ ".NET", "ASP.NET", "Resources", "Tips",]
+++
This is a list of of three common mistakes made by developers who start
using Web Page Resources in ASP.NET.  
  
<span style="font-weight:bold;">1. Not using the right format for the
name of a local resources file</span>  
  
The format of the name of a local resources file should be:
PageName.<span style="font-style:italic;">PageExtension</span>.resx.  
  
If you don't add the page extension (Aspx, Ascx), you will get the
Exception "The resource object with key 'PageTitle' was not found.".  
  
<span style="font-weight:bold;">2. Not adding an App\_LocalResources
folder to each subfolder</span>  
  
Each subfolder must have it's own App\_LocalResources folder, else
ASP.NET will not be able the find the resource, leading to the "The
resource object with key 'PageTitle' was not found." Exception again.  
  
<span style="font-weight:bold;">3. Not understanding the difference
between GlobalResources and LocalResources</span>  
  
In general global resources should be used when you need a resourcekey
in multiple pages through your site. Local resources are
page-specific.  
  
[This article](http://msdn.microsoft.com/en-us/library/ms227427.aspx) on
MSDN contains a great summary.  
  

> You can use any combination of global and local resource files in the
> Web application. Generally, you add resources to a global resource
> file when you want to share the resources between pages. Resources in
> global resource files are also strongly typed for when you want to
> access the files programmatically.  
>   
> However, global resource files can become large, if you store all
> localized resources in them. Global resource files can also be more
> difficult to manage, if more than one developer is working on
> different pages but in a single resource file.  
>   
> Local resource files make it easier to manage resources for a single
> ASP.NET Web page. But you cannot share resources between pages.
> Additionally, you might create lots of local resource files, if you
> have many pages that must be localized into many languages. If sites
> are large with many folders and languages, local resources can quickly
> expand the number of assemblies in the application domain.  
>   
> When you make a change to a default resource file, either local or
> global, ASP.NET recompiles the resources and restarts the ASP.NET
> application. This can affect the overall performance of your site. If
> you add satellite resource files, it does not cause a recompilation of
> resources, but the ASP.NET application will restart.
