+++
title = "Cannot Start Service from the command line or debugger. A Windows Service must first be installed (using installutil.exe).."
slug = "2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe"
published = 2010-03-13T16:36:00.005000+01:00
author = "Jef Claes"
tags = [ "code",]
url = "cannot-start-service-from-command-line.html"
+++
When you create a new Windows Service project and try to debug it,
Visual Studio will show you a Windows Service Start Failure with the
message `Cannot Start Service from the command line or debugger. A
Windows Service must first be installed (using installutil.exe) and then
started with the Server Explorer, Windows Services Administrative tool
or the NET START command.`.
  
[![](/post/images/thumbnails/2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe-serviceError.JPG)](/post/images/2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe-serviceError.JPG)  
The trick my team and I use to workaround this problem, makes use of the
service `Debug` flag. If the `Debug` flag is on, we just start the service
by using our own public `Start` method. When the `OnStart` event is fired in
the service itself, we call the same public `Start` method.  
  
This goes in your service.  

```csharp
protected override void OnStart(string[] args)
{
    Start();
}

public void Start()
{
    //Start!
}
```
  
And this goes in `Program.cs`.  

```csharp
namespace UdpListener
{
    static class Program
    {
        static void Main()
        {
            #if (!DEBUG)
                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[] 
                { 
                    new UdpListener() 
                };

                ServiceBase.Run(ServicesToRun);
            #else
                UdpListener listener = new UdpListener();

                listener.Start();
            #endif           
        }
    }
}
```

You can set the `Debug` flag of your service in your service properties.  
  
[![](/post/images/thumbnails/2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe-debug.JPG)](/post/images/2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe-debug.JPG)  
  
The only problem with this solution is that you can't debug your `OnStop`
event but this hasn't been an issue for us so far.  