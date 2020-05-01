+++
title = "Debugging \"SubReport could not be shown.\""
slug = "2009-09-09-debugging-subreport-could-not-be-shown"
published = 2009-09-09T18:41:00.009000+02:00
author = "Jef Claes"
tags = [ ".NET", "Visual Studio", "ASP.NET", "Reporting", "Tips",]
+++
[![](/post/images/thumbnails/2009-09-09-debugging-subreport-could-not-be-shown-128819720189651997.jpg)](/post/images/2009-09-09-debugging-subreport-could-not-be-shown-128819720189651997.jpg)I've
been upgrading a local report which contains multiple subreports, and
yes I got that "SubReport could not be shown." error more than once.  
  
Debugging this error is a pain in the a.. All you get is "SubReport
could not be shown.", <span style="font-style:italic;">making me want to
punch my screen and scream "BUT WHY?"</span>  
  
Just before breaking my screen and going on full tilt, I decided to take
a step back and run through my checklist.  
  
Here it goes..  
  
<span style="font-weight:bold;">Can the reportviewer find the
subreports?</span>  
  
If the subreports are in another location (other folder, other
assembly..), the reportviewer will not find them.  
  
The solution for this problem is using the
[LoadReportDefinition](http://msdn.microsoft.com/en-us/library/microsoft.reporting.webforms.report.loadreportdefinition(VS.80).aspx)
method and passing the report definition as a stream. An example can be
found in
[this](http://jclaes.blogspot.com/2009/05/programmaticallydynamically-building.html)
post.  
  
<span style="font-weight:bold;">Are you passing all parameters?</span>  
  
Doublecheck your [report
parameters](http://www.gotreportviewer.com/localmodeparameters/index.html).  
  
<span style="font-weight:bold;">Are you passing all the required/correct
data to the report?</span>  
  
Are you handling the
[SubReportProcessing](http://msdn.microsoft.com/en-us/library/microsoft.reporting.winforms.localreport.subreportprocessing(VS.80).aspx)
event, to pass the data to the subreports, not the main report?  
  
Did the database definition change? Did a query break? Is the structure
of the query still the same as defined in your report definition?  
  
<span style="font-weight:bold;">Are there other things to add to this
list?</span>
