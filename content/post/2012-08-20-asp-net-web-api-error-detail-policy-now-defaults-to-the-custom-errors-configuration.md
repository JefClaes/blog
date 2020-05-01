+++
title = "ASP.NET Web API error detail policy now defaults to the custom errors configuration"
slug = "2012-08-20-asp-net-web-api-error-detail-policy-now-defaults-to-the-custom-errors-configuration"
published = 2012-08-20T08:50:00.001000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC", "ASP.NET", "REST", "Web API", "Tips",]
+++
While working on an already updated [ASP.NET Web
API](http://www.asp.net/web-api) project, I noticed an extra value in
[the IncludeErrorDetailPolicy
enumeration](http://msdn.microsoft.com/en-us/library/system.web.http.includeerrordetailpolicy(v=vs.108).aspx).
The IncludeErrorDetailPolicy configuration tells the Web API host when
it's allowed to include full error details in responses. Before
updating, the RC version of the IncludeErrorDetailPolicy enumeration
only had three possible values: LocalOnly, Always and Never. With the
released version comes a new value: Default.  

    // Summary:
    // Use the default behavior for the host environment. For ASP.NET hosting, use
    // the value from the customErrors element in the Web.config file. For  self-hosting,
    // use the value System.Web.Http.IncludeErrorDetailPolicy.LocalOnly.
    Default = 0,

So now, with the default policy enabled, the ASP.NET host will look
inside the custom errors element in the web.config by default, to
determine whether it should include error details or not. This makes for
the error detail behavior of Web API to always be consistent with the
one of MVC and WebForms in the same application.  
  
Those that have yet to have their first look at ASP.NET Web API will
probably take this behavior for granted. But [we will never
forget](http://lostechies.com/jimmybogard/2012/04/18/custom-errors-and-error-detail-policy-in-asp-net-web-api/).
