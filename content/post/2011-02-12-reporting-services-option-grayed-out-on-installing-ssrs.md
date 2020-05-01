+++
title = "Reporting Services option grayed out on installing SSRS"
slug = "2011-02-12-reporting-services-option-grayed-out-on-installing-ssrs"
published = 2011-02-12T17:50:00.001000+01:00
author = "Jef Claes"
tags = [ "Reporting", "Windows", "Tips",]
+++
Even though our title says Developer, it's hard for most of us to escape
doing a system administrator task once in a while.  
  
I had to add [SQL Server Reporting
Services](http://en.wikipedia.org/wiki/SQL_Server_Reporting_Services) to
an existing SQL Server 2005 installation. This shouldn't be a big deal.
Mount the SQL Server installation image, run the setup and follow the
installation wizard to add extra components. Arriving at the step where
I should be able to select Reporting Services, the Reporting Services
option was grayed out.  
  
[![](/post/images/thumbnails/2011-02-12-reporting-services-option-grayed-out-on-installing-ssrs-ReportingServicesGrayedOut.PNG)](/post/images/2011-02-12-reporting-services-option-grayed-out-on-installing-ssrs-ReportingServicesGrayedOut.PNG)  
After some Googling I found out that IIS needs to be installed to be
able to install Reporting Services. I opened the [Services
snap-in](http://technet.microsoft.com/en-us/library/cc757797(WS.10).aspx)
and saw that the [World Wide Web Publishing
service](http://technet.microsoft.com/en-us/library/cc734944(WS.10).aspx)
already was installed, but it wasn't running... After starting the
service, the Reporting Services option was no longer grayed out. The
installer should have been smart enough to give a hint in my opinion,
terrible user experience.  
  
**So to make a long story short, make sure IIS is installed and that the
World Web Web Publishing service is running!**  
  
I hope I was able to soften some of the system administrator pain.
