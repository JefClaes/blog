+++
title = "Hello world with Kayak and OWIN"
slug = "2011-01-23-hello-world-with-kayak-and-owin"
published = 2011-01-23T19:00:00.001000+01:00
author = "Jef Claes"
tags = [ ".NET",]
+++
[Kayak](https://github.com/kayak/kayak) is a lightweight opensource C\#
webserver which implements [OWIN](http://owin.github.com/spec.html).
[OWIN](http://owin.github.com/spec.html) stands for Open Web Interface
for .NET.  
  
**Hello World**  
  
Hosting your own application using Kayak is relatively simple.  
  
In this example I'm using a console application to run the Kayak
webserver. This application has one dependency: the Kayak project.  
  
First create a new instance of the DotNetServer. This class is an
IKayakServer implementation using
[System.NET.Sockets.Socket](http://msdn.microsoft.com/en-us/library/system.net.sockets.socket.aspx).
Once the instance is created you can call the Start() method. This
method returns an
[IDisposable](http://msdn.microsoft.com/en-us/library/system.idisposable.aspx),
which needs to be disposed once the server should stop listening. Once
the server is started you can host your OwinApplication, which is a
delegate with three arguments.  
  

       1:  static void Main() {

       2:      var server = new DotNetServer();

       3:      var pipe = server.Start();

       4:   

       5:      server.Host(HelloWorldOwinApp);

       6:   

       7:      Console.WriteLine(string.Format("Listening on {0}..", server.ListenEndPoint));

       8:      Console.ReadLine();

       9:   

      10:      pipe.Dispose();

      11:  }

  
The first argument is an environment dictionary which represents the
request the application needs to process. The second argument is a
response callback which defines the status, headers and bodydata of the
HTTP response. The final argument is the error callback which can be
used to trap internal errors and return an appropriate response.  
  
In this example, I'm reading the path from the environment dictionary
and I'm only returning a simple "Hello world" HTTP response when it
equals "/HelloWorld".  
  

       1:  public static void HelloWorldOwinApp(IDictionary<string, object> env,

       2:      Action<string, IDictionary<string, IList<string>>, IEnumerable<object>> response,

       3:      Action<Exception> error) {

       4:          var path = env["Owin.RequestUri"] as string;

       5:   

       6:          if (path.Equals("/HelloWorld", StringComparison.OrdinalIgnoreCase)) {

       7:              var status = "200 OK";

       8:              var headers = new Dictionary<string, IList<string>>(){

       9:                                  { "Content-Type", new string[] {"text/plain"}}

      10:                              };

      11:              var bodyData = new object[] { Encoding.ASCII.GetBytes("Hello world!") };

      12:   

      13:              response(status, headers, bodyData);

      14:          }               

      15:  }

  
  
If you run this example you should be able to browse to
<http://localhost:1111/HelloWorld> and get a response.  
  
[![](/post/images/thumbnails/2011-01-23-hello-world-with-kayak-and-owin-owinhelloworld.PNG)](/post/images/2011-01-23-hello-world-with-kayak-and-owin-owinhelloworld.PNG)  
**Conclusion**  
  
I thinks it's great we can start building our own lightweight webservers
where the abstractions are in the perfect size to give us full control,
without getting too complicated. I foresee a promising future for the
OWIN initiative and the Kayak project.  
  
**Download the source**  
  
You can [download the source of this example
here](http://dl.dropbox.com/u/19698383/Blog/KayakHelloWorld.rar).
