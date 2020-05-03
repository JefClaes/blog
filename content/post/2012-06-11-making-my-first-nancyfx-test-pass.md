+++
title = "Making my first NancyFx test pass"
slug = "2012-06-11-making-my-first-nancyfx-test-pass"
published = 2012-06-11T16:47:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2012/06/making-my-first-nancyfx-test-pass.html"
+++
Like I already said last week, I have been dabbling a bit with [NancyFx](http://nancyfx.org/) lately.  
  
This week I took a serious look at testing Nancy modules and Razor
views. Due to Nancy's defaults and conventions, it takes a little while
to set up Nancy in a test context. Then again, Nancy's granularity makes
it simple enough to set up a solid test infrastructure by replacing some
of its building blocks.  
  
Like always, I had to go through several iterations to get it right.  
  
### A first attempt
  
The first test I wrote looked something like this. This test simply
asserts whether a GET request to the root of my application returns a
`200 OK` status code.  

```csharp
[TestMethod]
public void root_should_return_response_ok()
{        
    var browser = new Browser(new DefaultNancyBootstrapper());

    var response = browser.Get("/");

    Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
}
```

`Assert.AreEqual failed. Expected:<OK>. Actual:<NotFound>.`

### Telling Nancy which modules to use  
  
I figured out I had to tell Nancy which modules to load. You can do this
by using the configurable bootstrapper, which gives you an API to
configure parts of Nancy yourself.  

```csharp
var bootstrapper = new ConfigurableBootstrapper(with =>
{
    with.Module<RootModule>();               
});
var browser = new Browser(bootstrapper);
```

Running this test, I no longer got a NotFound result, but an exception.
Making progress.  

```
Test method RootModuleTests.root_should_return_response_ok threw exception: 
System.Exception: ConfigurableBootstrapper Exception ---> 
                    Nancy.RequestExecutionException: Oh noes! ---> 
                    Nancy.ViewEngines.ViewNotFoundException: Unable to locate view 'HomeView'
Currently available view engine extensions: sshtml,html,htm
Locations inspected: HomeView,views/HomeView,views/HomeView,/HomeView,views/Root/HomeView,Root/HomeView
```

### Where is the view engine?  
  
On inspecting the exception, I noticed that the cshtml view engine
extension was missing from the list.  
  
To add the view engine, you can just add a reference to the
`Nancy.ViewEngines.Razor` assembly. Nancy will pick up the new engine
automatically.  

```
Test method RootModuleTests.root_should_return_response_ok threw exception: 
System.Exception: ConfigurableBootstrapper Exception ---> 
                    Nancy.RequestExecutionException: Oh noes! ---> 
                    Nancy.ViewEngines.ViewNotFoundException: Unable to locate view 'HomeView'
Currently available view engine extensions: sshtml,html,htm,cshtml,vbhtml
Locations inspected: HomeView,views/HomeView,views/HomeView,/HomeView,views/Root/HomeView,Root/HomeView
```

### Locating the views  
  
This time around we get a slightly different exception; the razor view
engine extension is available, but Nancy is still having trouble finding
the views - which is normal. Nancy is running in a different context
now, so the default rootpathprovider will return the wrong path.
Implementing another one is children's play.  

```csharp
public class TestRootPathProvider : IRootPathProvider
{    
    public string GetRootPath()
    {
        return "C:\MyProject\";
    }
}
```

I discovered that you don't even need to use the configurable
bootstrapper to override the IRoothPathProvider; Nancy seems to pick up
the new implementation by herself.  
  
The hardcoded path will work on your machine, but not on the build
server. In my second iteration, I made the implementation smarter by
traversing my way through parent directories looking for my views folder - starting from my tests out folder all the way up to my web application
folder.  

```csharp
public class TestRootPathProvider : IRootPathProvider
{
    private static string _cachedRootPath;

    public string GetRootPath()
    {
        if (!string.IsNullOrEmpty(_cachedRootPath))
            return _cachedRootPath;

        var currentDirectory = new DirectoryInfo(Environment.CurrentDirectory);
        
        bool rootPathFound = false;            
        while (!rootPathFound)
        {
            var directoriesContainingViewFolder = currentDirectory.GetDirectories(
                        "Views", SearchOption.AllDirectories);
            if (directoriesContainingViewFolder.Any())
            {
                _cachedRootPath = directoriesContainingViewFolder.First().FullName;
                rootPathFound = true;
            }

            currentDirectory = currentDirectory.Parent;
        }

        return _cachedRootPath;
    }
}
```

`Result: Passed`

I was happy to find out that this technique works for the MSTest runner,
[NCrunch](http://www.ncrunch.net/) and [Appharbor](https://appharbor.com/).  
  
There is one more way you can go at this though, which works and maybe
even is the 'recommended' technique, but also is [a lot more cumbersome](http://stackoverflow.com/questions/3738819/do-mstest-deployment-items-only-work-when-present-in-the-project-test-settings-f): use the [DeploymentItem](http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.deploymentitemattribute(v=vs.80).aspx) attribute to copy the views folder to your tests out folder.  
  
### To recapitulate
  
I hope this post documented some useful techniques to get started
testing Nancy's modules and views:
1. Use the configurable bootstrapper to add your modules
2. Reference the correct view engine
3. Implement a rootpathprovider telling Nancy where it can find her views

Only a few days ago, [@thecodejunkie](https://twitter.com/#!/thecodejunkie) made a [ticket on GitHub](https://github.com/NancyFx/Nancy/issues/633) addressing some of these issues. I'm pretty confident we can smooth out these rough edges to make Nancy tests also walk the super-duper-happy-path.
