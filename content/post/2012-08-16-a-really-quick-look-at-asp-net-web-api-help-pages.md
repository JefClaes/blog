+++
title = "A really quick look at ASP.NET Web API Help Pages"
slug = "2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages"
published = 2012-08-16T21:41:00.001000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC", ".NET", "REST", "Web API",]
+++
While skimming over [future features of ASP.NET Web
API](http://blogs.msdn.com/b/henrikn/archive/2012/08/15/asp-net-web-api-released-and-a-preview-of-what-s-next.aspx),
I came across the ASP.NET Web API Help Page feature. I couldn't find an
introduction online, and the Nuget package has only been downloaded 16
times, so I had to have a really quick look. I documented my baby steps
below.  
  
So, I had a really simple ASP.NET MVC4 project, with one API controller
exposing tweets.  

    public class TweetsController : ApiController
    {   
        /// <summary>
        /// Get a <c>Tweet</c> by its identifier.
        /// </summary>
        /// <param name="id">Id of the tweet</param>
        /// <returns>A <c>Tweet</c></returns>
        public Tweet Get(int id) 
        {
            //...
        }

        /// <summary>
        /// Adds a <c>Tweet</c>
        /// </summary>
        /// <param name="tweet">An instance of <c>Tweet</c></param>.
        public void Post(Tweet tweet) 
        { 
            //...
        }      

        /// <summary>
        /// Deletes a <c>Tweet</c> by its identifier.
        /// </summary>
        /// <param name="id">Id of the <c>Tweet</c></param>
        public void Delete(int id) 
        { 
            //...
        }
    }

    public class Tweet
    {
        public int Id { get; set; }

        public string Message { get; set; }

        public string User { get; set; }
    }

To add the Help Pages feature, I added [the Nuget
package](http://nuget.org/packages/Microsoft.AspNet.WebApi.HelpPage) to
my MVC project. This adds a new area, containing a bunch of code.  
  

[![](/post/images/thumbnails/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-Area.PNG)](/post/images/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-Area.PNG)

  
Browsing to the area's default url now, you already get to see something
like this.  
  

[![](/post/images/thumbnails/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-HelpPage.PNG)](/post/images/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-HelpPage.PNG)

  

[![](/post/images/thumbnails/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-HelpPage2.PNG)](/post/images/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-HelpPage2.PNG)

  
There are a few things missing though. Most importantly, where is the
documentation I provided in the controller?  
  
To expose the existing documentation, enable generation of the XML
output.  
  

[![](/post/images/thumbnails/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-XMLDocumentationFile.PNG)](/post/images/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-XMLDocumentationFile.PNG)

  
Then open the HelpPageConfig class, and set the documentation provider -
we can use the default implementation included in the package.  

    config.SetDocumentationProvider(new XmlDocumentationProvider(
        HttpContext.Current.Server.MapPath("~/App_Data/Documentation.xml")));

  

[![](/post/images/thumbnails/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-workingdocumentation.PNG)](/post/images/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-workingdocumentation.PNG)

  

[![](/post/images/thumbnails/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-workingdocumentation2.PNG)](/post/images/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-workingdocumentation2.PNG)

  
That looks better. There is one more thing I'd like to get working:
samples of the different representations.  
This can also be configured in the HelpPageConfig class.  

    config.SetSampleObjects(new Dictionary<Type, object>
            {
                {typeof(Tweet), new Tweet() 
                    { 
                        Id = 1, 
                        Message = "sample_message", 
                        User = "sample user"  
                }},               
                {typeof(string), "sample string"},
                {typeof(IEnumerable<string>), new string[]{"sample 1", "sample 2"}}
            });

This produces a nice sample for consumers of the API.  
  

[![](/post/images/thumbnails/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-representations.PNG)](/post/images/2012-08-16-a-really-quick-look-at-asp-net-web-api-help-pages-representations.PNG)

  
All of this took me five minutes to get working. There seems to be a lot
of room for optimizations and customizations. You can configure a bunch
of stuff in a centralized spot, tweak the code - it's not in a separate
assembly, and you can adapt the views however you like.
