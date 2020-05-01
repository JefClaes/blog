+++
title = "Supporting the OPTIONS verb in ASP.NET Web API"
slug = "2012-09-02-supporting-the-options-verb-in-asp-net-web-api"
published = 2012-09-02T18:27:00.001000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "MVC", "ASP.NET MVC", "ASP.NET", "REST", "Web API",]
+++
[ASP.NET Web API](http://www.asp.net/web-api) controllers support only
four HTTP verbs by convention: GET, PUT, POST and DELETE. The [full list
of existing HTTP verbs](http://annevankesteren.nl/2007/10/http-methods)
is more extensive though. One of those unsupported verbs which can be
particularly useful for API discovery and documentation is the [OPTIONS
verb](http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html).  

> The OPTIONS method represents a request for information about the
> communication options available on the request/response chain
> identified by the Request-URI. This method allows the client to
> determine the options and/or requirements associated with a resource,
> or the capabilities of a server, without implying a resource action or
> initiating a resource retrieval.

If we wanted to implement controller support for the OPTIONS verb, we
could manually map an action to the verb by decorating it with an
AcceptVerbs attribute, and making the action return a response with a
relevant Access-Control-Allow-Methods header.  
  
For a values controller, with a GET and DELETE action, it could look
like this.  

    public class ValuesController : ApiController
    {        
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }                 
        
        public void Delete(int id) { }

        [AcceptVerbs("OPTIONS")]
        public HttpResponseMessage Options()
        {
            var resp = new HttpResponseMessage(HttpStatusCode.OK);
            resp.Headers.Add("Access-Control-Allow-Origin", "*");
            resp.Headers.Add("Access-Control-Allow-Methods", "GET,DELETE");

            return resp;
        }
    }

If we now make an OPTIONS request to
http://localhost:53314/api/values..  

    OPTIONS http://localhost:53314/api/values HTTP/1.1
    User-Agent: Fiddler
    Host: localhost:53314

..we receive following response.  

    HTTP/1.1 200 OK
    Server: ASP.NET Development Server/10.0.0.0
    Date: Sun, 02 Sep 2012 13:46:21 GMT
    X-AspNet-Version: 4.0.30319
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET,DELETE
    Cache-Control: no-cache
    Pragma: no-cache
    Expires: -1
    Content-Length: 0
    Connection: Close

While this works, it's not a great solution. We don't want to maintain
the list of supported verbs manually, and we certainly don't want to
repeat this for each controller.  
  
ASP.NET Web API provides a nice way to have a more high level solution:
[HTTP message
handlers](http://www.asp.net/web-api/overview/working-with-http/http-message-handlers).
These basically behave as HTTP intermediaries, meaning we can intercept
each OPTIONS request early, and bypass the whole request chain.  
Another useful component we can make good use of is the default
[ApiExplorer](http://blogs.msdn.com/b/yaohuang1/archive/2012/05/21/asp-net-web-api-generating-a-web-api-help-page-using-apiexplorer.aspx);
this abstraction allows us to obtain metadata of our API's stucture.  
  
To create a new HTTP message handler, I inherited from the
DelegatingHandler class, and overwrote the SendAsync method. Here we'll
intercept the request when the verb equals "OPTIONS". An instance of the
Api explorer can be resolved through the global configuration. I grab
the requested controller from the request route data, and use that to
search the Api explorer's ApiDescriptions collection for its associated
actions, and its associated verbs. Once I get the outcome of this
lookup, and at least one verb is supported (\*), I'll return an OK
response with the relevant headers, and thus short circuit the
request.  

    public class OptionsHttpMessageHandler : DelegatingHandler
    {
      protected override Task<HttpResponseMessage> SendAsync(
          HttpRequestMessage request, CancellationToken cancellationToken)
      {
          if (request.Method == HttpMethod.Options)
          {
              var apiExplorer = GlobalConfiguration.Configuration.Services.GetApiExplorer();

              var controllerRequested = request.GetRouteData().Values["controller"] as string;              
              var supportedMethods = apiExplorer.ApiDescriptions
                  .Where(d => 
                    {  
                        var controller = d.ActionDescriptor.ControllerDescriptor.ControllerName;
                        return string.Equals(
                            controller, controllerRequested, StringComparison.OrdinalIgnoreCase);
                    })
                  .Select(d => d.HttpMethod.Method)
                  .Distinct();

              if (!supportedMethods.Any())
                 return Task.Factory.StartNew(
                     () => request.CreateResponse(HttpStatusCode.NotFound));

              return Task.Factory.StartNew(() =>
                {
                    var resp = new HttpResponseMessage(HttpStatusCode.OK);
                    resp.Headers.Add("Access-Control-Allow-Origin", "*");
                    resp.Headers.Add(
                        "Access-Control-Allow-Methods", string.Join(",", supportedMethods));

                    return resp;
                });
        }

        return base.SendAsync(request, cancellationToken);
      }
    }

Register this HTTP message handler by adding it to the configuration.  

    GlobalConfiguration.Configuration.MessageHandlers.Add(new OptionsHttpMessageHandler());

This second solution still yields the same result, but is far more
scalable.  
  
*(\*) When a resource can't be read nor manipulated, it must not exist
right? *
