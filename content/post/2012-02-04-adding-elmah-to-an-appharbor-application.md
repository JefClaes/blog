+++
title = "Adding ELMAH to an AppHarbor application"
slug = "2012-02-04-adding-elmah-to-an-appharbor-application"
published = 2012-02-04T15:17:00.002000+01:00
author = "Jef Claes"
tags = [ "ASP.NET MVC", "ASP.NET", "Tips",]
+++
For those who haven't heard of [ELMAH](http://code.google.com/p/elmah/)
yet, here is the project description.  

> ELMAH (Error Logging Modules and Handlers) is an application-wide
> error logging facility that is completely pluggable. It can be
> dynamically added to a running ASP.NET web application, or even all
> ASP.NET web applications on a machine, without any need for
> re-compilation or re-deployment.

While ELMAH is completely **not** [AppHarbor](https://appharbor.com/)
specific, there do seem to be a [fair
amount](http://feedback.appharbor.com/forums/95687-general/suggestions/1423059-add-support-for-elmah)
of
[questions](http://support.appharbor.com/discussions/problems/541-getting-elmah-to-work)
on [the AppHarbor support
forums](http://support.appharbor.com/discussions/problems/18-permissions-for-elmahaxd)
on how to get ELMAH running. I just installed and configured ELMAH for
one of my AppHarbor ASP.NET MVC3 applications, so I thought it would be
nice to share and give something back to the AppHarbor support guys.  
  
I think enabling ELMAH shouldn't take more than 10 minutes if you follow
this tutorial.  
  
**Installation**  
  
The easiest way to add ELMAH to your web application is by installing
[the nuget package](http://www.nuget.org/packages/elmah).  

    PM> Install-Package elmah
    Attempting to resolve dependency 'elmah.corelibrary (= 1.2)'.
    Successfully installed 'elmah 1.2.0.1'.
    Successfully added 'elmah 1.2.0.1' to Docary.

Once this is done you will find a newly added Elmah reference and a
changed web.config.  
  
I'm not going to list all the changes to the web.config here. If you're
interested in what the package does to your web.config, you should just
run a [git
diff](http://book.git-scm.com/3_comparing_commits_-_git_diff.html).  
  
**Error log storage**  
  
You have to tell ELMAH where it should store the logs. A list of error
log implementations can be found [on the project
wiki](http://code.google.com/p/elmah/wiki/ErrorLogImplementations).  
  
I choose to use the in-memory error log *for now*. Add the elmah section
and errorLog element to your web.config.  

    <elmah>    
        <errorLog type="Elmah.MemoryErrorLog, Elmah" size="250" />
    </elmah>

**Remote access**  
  
By default you can only see the logging on the local machine. To enable
remote access, you have to add the security element to the elmah
section.  

    <elmah>
        <security allowRemoteAccess="1" />
        <errorLog type="Elmah.MemoryErrorLog, Elmah" size="250" />
    </elmah>

**Security**  
  
Now that you're allowing remote access, you want to [secure the logging
page](http://www.troyhunt.com/2012/01/aspnet-session-hijacking-with-google.html).
I used ASP.NET authorization to achieve this.  
  
Add the following element to your web.config, and make sure you change
the authorization configuration to the **relevant values**.  

    <location path="elmah.axd">
        <system.web>
          <httpHandlers>
            <add verb="POST,GET,HEAD" path="elmah.axd" type="Elmah.ErrorLogPageFactory, Elmah" />
          </httpHandlers>
          <authorization>
            <allow roles="SuperUser"/>
            <deny users="*" />
          </authorization>
        </system.web>
        <system.webServer>
          <handlers>
            <add name="ELMAH" verb="POST,GET,HEAD" path="elmah.axd" type="Elmah.ErrorLogPageFactory, Elmah" preCondition="integratedMode" />
          </handlers>
        </system.webServer>
    </location>

**Finished**  

**  
**

Push these changes, and you should be done. Navigate to elmah.axd in the
root of your web application and you should see something like this.  
  
[![](/post/images/thumbnails/2012-02-04-adding-elmah-to-an-appharbor-application-Elmah.PNG)](/post/images/2012-02-04-adding-elmah-to-an-appharbor-application-Elmah.PNG)  
  
It should be easier now to start playing with [more advanced ELMAH
options](http://code.google.com/p/elmah/wiki).
