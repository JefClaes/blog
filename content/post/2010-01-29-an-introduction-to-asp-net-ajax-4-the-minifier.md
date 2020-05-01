+++
title = "An introduction to ASP.NET Ajax 4: The Minifier"
slug = "2010-01-29-an-introduction-to-asp-net-ajax-4-the-minifier"
published = 2010-01-29T08:32:00.001000+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "AJAX",]
+++
The Minifier is an utility which "minifies" your scripts: it reduces the
size of your scripts by removing comments, removing spaces, renaming
local variables and removing unreachable code.  
  
You can
[download](http://aspnet.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=34488)
the Minifier on Codeplex.  
  
<span style="font-weight:bold;">Before and after</span>  
  
The unminified script looks like this.  

  

       1:  //This function does something

       2:  function doSomething(valueOne, valueTwo){

       3:      var result = valueOne + valueTwo;

       4:      return result;

       5:  }

  

After hypercrunching the script looks likes this.  

  

       1:  function doSomething(a,b){var c=a+b;return c}
