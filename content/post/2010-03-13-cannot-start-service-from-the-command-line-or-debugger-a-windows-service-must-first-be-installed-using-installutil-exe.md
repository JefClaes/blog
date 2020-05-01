+++
title = "Cannot Start Service from the command line or debugger. A Windows Service must first be installed (using installutil.exe).."
slug = "2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe"
published = 2010-03-13T16:36:00.005000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "Windows Services", "Tips",]
+++
When you create a new Windows Service project and try to debug it,
Visual Studio will show you a Windows Service Start Failure with the
message "Cannot Start Service from the command line or debugger. A
Windows Service must first be installed (using installutil.exe) and then
started with the Server Explorer, Windows Services Administrative tool
or the NET START command.".  
  
[![](/post/images/thumbnails/2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe-serviceError.JPG)](/post/images/2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe-serviceError.JPG)  
The trick my team and I use to workaround this problem, makes use of the
service Debug flag. If the Debug flag is on, we just start the service
by using our own public Start method. When the OnStart event is fired in
the service itself, we call the same public Start method.  
  
This goes in your service.  

  

       1:  protected override void OnStart(string[] args)

       2:  {

       3:       Start();

       4:  }

       5:       

       6:  public void Start()

       7:  {

       8:       //Start!

       9:  }

  
  
And this goes in Program.cs.  

  

       1:  namespace UdpListener

       2:  {

       3:      static class Program

       4:      {

       5:          /// <summary>

       6:          /// The main entry point for the application.

       7:          /// </summary>

       8:          static void Main()

       9:          {

      10:  #if (!DEBUG)

      11:              ServiceBase[] ServicesToRun;

      12:              ServicesToRun = new ServiceBase[] 

      13:              { 

      14:                  new UdpListener() 

      15:              };

      16:              ServiceBase.Run(ServicesToRun);

      17:  #else

      18:              UdpListener listener = new UdpListener();

      19:              listener.Start();

      20:  #endif           

      21:          }

      22:      }

      23:  }

  
You can set the Debug flag of your service in your service properties.  
  
[![](/post/images/thumbnails/2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe-debug.JPG)](/post/images/2010-03-13-cannot-start-service-from-the-command-line-or-debugger-a-windows-service-must-first-be-installed-using-installutil-exe-debug.JPG)  
  
The only problem with this solution is that you can't debug your OnStop
event but this hasn't been an issue for us so far.  
  
Other ways to solve this issue can be found here:  
- [MSDN: How to: Debug Windows Service
Applications](http://msdn.microsoft.com/en-us/library/7a50syb3.aspx)  
- [KB824344: How to debug Windows
services](http://support.microsoft.com/kb/824344)  
- [MSDN: How to: Launch the Debugger
Automatically](http://msdn.microsoft.com/en-us/library/a329t4ed.aspx)
