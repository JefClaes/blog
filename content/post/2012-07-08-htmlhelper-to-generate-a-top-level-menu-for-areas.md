+++
title = "HtmlHelper to generate a top-level menu for areas"
slug = "2012-07-08-htmlhelper-to-generate-a-top-level-menu-for-areas"
published = 2012-07-08T19:10:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC", "CSS", "ASP.NET",]
+++
Last week, we had to set up a new ASP.NET MVC web application, using a
somewhat customized [Twitter
Bootstrap](http://twitter.github.com/bootstrap/) build. Because the
application has multiple functional contexts, we divided it in multiple
parts using areas. Since these areas were a one-to-one mapping with the
top-level menu items, we tried abstracting the creation of the menu
items, ánd the management of setting the active item, into an
HtmlHelper.  
  
Let's say, for this example, that we have six areas: Images, Maps, Play,
Search, Video and Blog, and we want to render a list item for each one
of them.  

    <div class="nav-collapse collapse">
        <ul class="nav">
            // Add list items         
        </ul>
    </div>

The first solution we tried, assumed we needed an extreme
low-maintenance solution, for which we would write some infrastructure
once, and then be able to just create new areas without having to think
about updating the top-level menu.  
  
This solution reflected over all the types looking for classes which
inherit from the AreaRegistration class. Once you get a list of all the
area names, you can iterate over them and create a list item for each
one of them, using an instance of UrlHelper to resolve the associated
url. You have to impose some routing convention to make the url lookup
robust though; in this example, I assume the default route is
sufficient. To be able to mark the active area with a css class, you can
get the active areaname from the viewcontext, and use that to compare to
the iterand value.  

    public static class TopMenuExtensions
    {
        private static IEnumerable<string> _areaNames;

        public static MvcHtmlString RenderTopMenuItems(this HtmlHelper helper)
        {
            var areaNames = GetAreaNames();
            var currentArea = helper.ViewContext.RouteData.DataTokens["area"] as string;

            var html = new StringBuilder();
            foreach (var areaName in areaNames)
            {
                var urlHelper = new UrlHelper(helper.ViewContext.RequestContext);
                var url = urlHelper.Action(string.Empty, string.Empty, new { area = areaName });
                // or similar
                // var url = urlHelper.RouteUrl(areaName + "_default");

                html.AppendLine(areaName.Equals(
                    currentArea, StringComparison.OrdinalIgnoreCase) ? 
                    "<li class='active'>" : "<li>");
                html.AppendLine(string.Format("<a href='{0}'>{1}</a>", url, areaName));
                html.AppendLine("</li>");
            }

            return new MvcHtmlString(html.ToString());
        }

        private static IEnumerable<string> GetAreaNames()
        {
            if (_areaNames == null)
            {
                _areaNames = Assembly
                    .GetExecutingAssembly()
                    .GetTypes()
                    .Where(t => t.IsClass && typeof(AreaRegistration).IsAssignableFrom(t))
                    .Select(a => (AreaRegistration)Activator.CreateInstance(a))
                    .Select(r => r.AreaName);
            }

            return _areaNames;
        }
    }

Now we can add following line to our \_Layout file, and be done with
it.  

    @Html.RenderTopMenuItems()  

While this works, we stumbled upon an annoyance pretty quickly: we
wanted to change the order of the menu items, but couldn't. We took a
step back, and momentarily considered decorating the arearegistrations
with an attribute, but since the added value is so small compared to the
extra complexity introduced, we decided just to throw the
overengineering out.  

    public static MvcHtmlString RenderTopMenuItems(
                 this HtmlHelper helper, IEnumerable<string> areaNames)
    {        
        var currentArea = helper.ViewContext.RouteData.DataTokens["area"] as string;

        var html = new StringBuilder();
        foreach (var areaName in areaNames)
        {
            var urlHelper = new UrlHelper(helper.ViewContext.RequestContext);
            var url = urlHelper.Action(string.Empty, string.Empty, new { area = areaName });
            
            if (url == null)
                throw new NullReferenceException(
                    string.Format("Couldn't find an url for the area {0}.", areaName));                
            html.AppendLine(areaName.Equals(
                              currentArea, StringComparison.OrdinalIgnoreCase) ? 
                              "<li class='active'>" : "<li>");
            html.AppendLine(string.Format("<a href='{0}'>{1}</a>", url, areaName));
            html.AppendLine("</li>");
        }

        return new MvcHtmlString(html.ToString());
    }       

The top-level menu items can now be rendered like this.  

    @Html.RenderTopMenuItems(new [] { "Search", "Images", "Blog", "Maps", "Play", "Video" } )

And the result looks like this.  
  

[![](/post/images/thumbnails/2012-07-08-htmlhelper-to-generate-a-top-level-menu-for-areas-TwitterBootstrapMenu.PNG)](/post/images/2012-07-08-htmlhelper-to-generate-a-top-level-menu-for-areas-TwitterBootstrapMenu.PNG)  
  

While you can go at this problem in a lot of different ways, I think
this is one of the most robust and most compact ways I have been able to
write this so far. How have you solved this in the past?
