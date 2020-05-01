+++
title = "An approach to mobile support in ASP.NET MVC"
slug = "2012-01-12-an-approach-to-mobile-support-in-asp-net-mvc"
published = 2012-01-12T21:16:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC",]
+++
I have been spending a decent amount of time working on a side project
in ASP.NET MVC lately. From the start, I planned on supporting mobile.
There are lots of ways you can use or extend ASP.NET MVC to support
mobile. Having tried several, I can say they all have their merits, and
the solution that will work for you very much depends on your
requirements. In this post I will run you over the implementation that
worked for me, for my specific requirements.

  
I *looked* at dynamically changing layouts, but I doubt if there is
anyone who has gotten a satisfying result with that. I also considered
rolling my own [view
engine](https://bitbucket.org/shanselman/mobileviewengines/changeset/48310997a453),
but after going with that for a little while, it became obvious that
this wasn't going to work out either. The behavior and functionalities
of my mobile version were quickly drifting away of those of the desktop
version. I could only reuse so few existing actions or viewmodels that I
was close to seeing the two versions as two completely different sites.
Let me elaborate a bit further. While it was often possible to use the
same viewmodels for both versions, it wasn't as clean as I wanted it to
be. I strive for lean views, and doing projections in the views just to
get the viewmodels in a workable format felt not right. Also, I had a
few cases where I had to split one action in multiple smaller ones to
make the flow work for the mobile version.  
  
Eventually I ended up dividing the desktop and mobile version in two
separate areas: desktop and mobile. Because some things do overlap, I
share a few abstract base controllers between the areas.  
  

[![](/post/images/thumbnails/2012-01-12-an-approach-to-mobile-support-in-asp-net-mvc-Areas_Mobile_Solution.PNG)](/post/images/2012-01-12-an-approach-to-mobile-support-in-asp-net-mvc-Areas_Mobile_Solution.PNG)

  
So when I look at the root of my application now, I see no more views.
Two things are left though: the HomeController and the
AccountController.  
  
I was able to pinpoint three points in the application where I need to
take special care of detecting the device or rerouting to the correct
area.  
  
The default route when the user types http://MySite in the address bar
still is Home/Default. In the default action of the HomeController I
want to detect the area I want to redirect to, based on the user agent.
Notice I'm using a permanent redirect, not wasting a HTTP request.  

    public class HomeController : Controller
    {
        public ActionResult Index()
        {           
            var view = Request.IsAuthenticated ? "Index" : "Welcome";
            var area = Request.ResolveDestinationArea();             

            return RedirectToActionPermanent(view, "Home", new { Area = area });            
        }
    }

This is the first scenario. When a user opens the homepage, I redirect
him to a specific area based on the user agent. If the user is on a
desktop he will be redirected to http://MySite/desktop/home and when
he's on a mobile device he will be redirected to
http://MySite/mobile/home. If this somewhat well-informed guess turns
out to be wrong, the user can still use a link to take him to the
correct area.  
  
There are two places left where I have to add some logic assuring the
user stays in the correct area. When the session is expired, I have to
redirect the user to the correct login page. Since you can only define
one loginUrl and there is no way of plugging into that, I let ASP.NET
redirect to the Account controller in my root.  

    <authentication mode="Forms">
      <forms loginUrl="~/Account/LogOn" timeout="2880"/>
    </authentication>

In the AccountController I can use the loginUrl in the querystring to
decide which area I want to redirect to. If it contains mobile, I
redirect to the mobile area. If it contains desktop, I redirect to the
desktop area.  

    public class AccountController : Controller
    {       
        public ActionResult LogOn()
        {
            return RedirectToAction(
                "LogOn", "Account", new { Area = Request.ResolveDestinationArea() });      
        }
    }

If the url were
http://MySite/Account/LogOn?ReturnUrl=%2fmobile%2fentry%2fadd, the
'mobile' substring in the ReturnUrl querystring would suffice to make
this work.  
  
Now there is one more place left where we want to take care of
redirecting to the correct area: in the error handling. Like always,
there are several ways of handling errors in ASP.NET MVC. I chose for
the one where I could handle exceptions outside the MVC pipeline and add
custom redirect logic easily. I'm talking about the Application\_Error
event in the Global.asax. When I'm handling this event, I can also use
the request url to resolve the correct area.  

    protected void Application_Error()
    {
        Response.TrySkipIisCustomErrors = true;

        var exception = Server.GetLastError();
        var httpException = exception as HttpException;

        Response.Clear();
        Server.ClearError();           
        
        var routeData = new RouteData();
        routeData.DataTokens["area"] = HttpContext.Current.Request.ResolveDestinationArea();
        routeData.Values["controller"] = "Errors";
        routeData.Values["action"] = "General";
        routeData.Values["exception"] = exception;
        
        Response.StatusCode = 500;
        
        if (httpException != null)
        {
            Response.StatusCode = httpException.GetHttpCode();
            if (Response.StatusCode == 403)
                routeData.Values["action"] = "Forbidden";
            if (Response.StatusCode == 404)
                routeData.Values["action"] = "NotFound";
        }

        var errorsController = (IController)new ErrorsController();
        var requestContext = new RequestContext(new HttpContextWrapper(Context), routeData);
        errorsController.Execute(requestContext);
    }

  
The url in this case would look like http://MySite/mobile/home, so the
'mobile' substring in the url should suffice to make the correct
decision.  
  
Pay attention, when you assemble a
[routedata](http://msdn.microsoft.com/en-us/library/system.web.routing.routedata.aspx)
object, you want to store the area value in the DataTokens property.  
  
So far we have identified three things we want to hold in account when
resolving the correct area: the url, the querystring of the url and the
user agent. These decisions are encapsulated into a
ResolveDestinationArea extension method on the HttpRequest class.  

    public static string ResolveDestinationArea(this HttpRequest request)
    {
        var mobileArea = "mobile";
        var desktopArea = "desktop";

        var uri = new Uri(request.Url.AbsoluteUri);
        // We want to search in the left part of the absolute uri
        var valueToSearchIn = uri.GetLeftPart(UriPartial.Path);
        
        // However if there is a returnUrl querystring, we want to search in that value
        var returnUrl = HttpUtility.ParseQueryString(uri.Query).Get("returnUrl");
        if (!string.IsNullOrEmpty(returnUrl))
            valueToSearchIn = returnUrl;
            
        // If the url contains 'mobile', redirect to the mobile area    
        var urlContainsMobile = 
        valueToSearchIn.IndexOf("mobile", StringComparison.OrdinalIgnoreCase) > -1;
        if (urlContainsMobile)
            return mobileArea;

        // If the url contains 'desktop', redirect to the desktop area
        var urlContainsDesktop = 
        valueToSearchIn.IndexOf("/desktop/", StringComparison.OrdinalIgnoreCase) > -1;
        if (urlContainsDesktop)
            return desktopArea;

        // If the url does not contain 'mobile' nor 'desktop', we have to look at the user agent
        return request.Browser.IsMobileDevice ? mobileArea : desktopArea;
    }

The implementation of the ResolveDestinationArea method is a bit
simplistic. Most sites would want to be a bit more careful about the way
the url is parsed. Only the second part of the url really matters
(/desktop/ or /mobile/), unless the returnUrl is present in the
querystring.  

  
**Conclusion**  
  
Like I said in the introduction, there are several ways you can use
ASP.NET MVC to support mobile devices. I think this pragmatic, maybe
naïve solution, works for me. There are only three scenarios where I
need to think about mobile devices: when the user enters the homepage,
when the user needs to authenticate again and when there is an unhandled
exception. All the logic is encapsulated in one little extension method
on the request object, making it easily changeable in the future.  
  
There is one extra scenario which I'm thinking of supporting in the
future. When the user explicitly chooses a different version, I can save
that preference to a cookie, so that I can use that as well to resolve
the area in the future.  

  
**If you already implemented mobile support in some way, what worked for
you?**
