+++
title = "Should I unit- or integration test my ASP.NET Web API services?"
slug = "2012-07-15-should-i-unit-or-integration-test-my-asp-net-web-api-services"
published = 2012-07-15T22:37:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2012/07/should-i-unit-or-integration-test-my.html"
+++
Over the last two weeks, preparing for a talk, I have been doing some
research on [ASP.NET Web API](http://www.asp.net/web-api). After working
my way through the API, and the implementation of certain features, I
looked at testing.  
  
Similar to ASP.NET MVC, Web API allows you to create relatively small
building blocks, which can replace parts of, or be added to an existing
default global setup. This makes it possible for us to test each
component in isolation:
[controllers](http://msdn.microsoft.com/en-us/library/system.web.http.apicontroller(v=vs.108).aspx),
[dependency
resolvers](http://www.asp.net/web-api/overview/extensibility/using-the-web-api-dependency-resolver),
filters, serialization, [type
formatters](http://www.asp.net/web-api/overview/formats-and-model-binding/media-formatters),
[messagehandlers](http://www.asp.net/web-api/overview/working-with-http/http-message-handlers)
and routing.  
  
Testing in isolation helps a great deal to keep the magnitude of things
to stuff in your head limited, and when you break something, you are
able to quickly pinpoint the origin of the error. What unit testing
fails to prove however, is the *correctness of your code when all the
little pieces are put together and configured*. And let it be that this
is extremely important when you're exposing an API.  

Looking at Web API, I would probably test most infrastructure in
isolation - filters, type formatters, messagehandlers and serialization,
because these tests will help pinpoint errors in components which will
affect a large amount of other code. I wouldn't test controllers and
routing in isolation though.  
  
I would test controllers and routing from a client's perspective;
meaning I'll send a request to and endpoint on the server, I'll go
through the infrastructure, and I'll assert the replied response. This
would exclude false positives or false negatives which can originate
when you unit test controllers and have to fake a bunch of
infrastructure just to get it working, while you do include *testing the
effect the real infrastructure has* on your incoming requests or
outgoing responses.  
  
An obvious counterargument might be starting and stopping a webserver in
your tests, and the associated performance hit. This isn't something to
worry about with Web API though; HttpServer is just another
HttpMessageHandler, which makes it possible to consume it using an
[HttpClient](http://code.msdn.microsoft.com/Introduction-to-HttpClient-4a2d9cee)
in-memory.  
  
So let me show you some code I wrote trying out these thoughts. The
first thing I did was exposing the hosting server's configuration to my
tests. This could be as simple as this.

```csharp
public class ServerSetup 
{
    public static HttpSelfHostConfiguration GetConfiguration(string baseAdress)
    {
        var config = new HttpSelfHostConfiguration(baseAdress);
        
        var kernel = new StandardKernel();
        kernel.Bind<IResumeStore>().To<ResumeStore>();
        
        config.Routes.MapHttpRoute(
            "DefaultApi", "api/{controller}/{id}",
            new { id = RouteParameter.Optional });
        config.MessageHandlers.Add(new MethodOverrideHandler());
        config.DependencyResolver = new NinjectDependencyResolver(kernel);

        return config;
    }
}
```

Now in my test I can grab this configuration, and just overwrite the
dependencies and the error detail policy. I can initialize an HttpClient
by passing in an HttpServer instance which uses the modified
configuration.  

```csharp
private HttpClient _client;

[TestInitialize]
public void Setup()
{
    var kernel = new StandardKernel();
    kernel.Bind<IResumeStore>().ToConstant(new Mock<IResumeStore>().Object);

    var config = ServerSetup.GetConfiguration("http://test");
    config.IncludeErrorDetailPolicy = IncludeErrorDetailPolicy.Always;                       
    config.DependencyResolver = new NinjectDependencyResolver(kernel);

    _client = new HttpClient(new HttpServer(config));
}

[TestMethod]
public void Post_Returns_HttpStatus_Code_Created()
{         
    var result = _client.PostAsync<Resume>(
            "http://test/api/resume", 
            new Resume("Jef", "Claes"), 
            new JsonMediaTypeFormatter()).Result;

    result.EnsureSuccessStatusCode();

    Assert.AreEqual(HttpStatusCode.Created, result.StatusCode);
}
```

Now I'm consuming my API almost exactly as a client would; my request
goes through the routing, infrastructure and the controller.
Infrastructure is still tested under isolation so finding problems there
is easy, but I now have the advantage of testing routing, the effect of
my real infrastructure and the logic in my controller actions in one
simple integration test. Remember, we are testing a delivery mechanism,
not an application; Web API controllers should be skinny as well.  
  
One drawback I stumbled upon is discoverability of controller
dependencies, but surprisingly that didn't bother me much. I can still
see an overview of all my dependencies in the controller's constructor,
it's not a disaster to not have intellisense.  
  
In general, I think this pragmatic approach to testing Web API
implementations gets as much value as possible from automated testing
with writing as little test code as possible, and without adding too
much complexity.  
  
What do you think about this approach to testing Web API solutions?
