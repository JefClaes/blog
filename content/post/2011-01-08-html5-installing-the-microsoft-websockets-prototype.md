+++
title = "HTML5: Installing the Microsoft WebSockets prototype"
slug = "2011-01-08-html5-installing-the-microsoft-websockets-prototype"
published = 2011-01-08T20:30:00+01:00
author = "Jef Claes"
tags = [ "javascript", "Browsers", "HTML5",]
+++
In December Microsoft launched the [HTML5
Labs](http://html5labs.interoperabilitybridges.com/) for experimental
HTML5 technologies still under development. With the launch, they also
released a [WebSockets
prototype](http://html5labs.interoperabilitybridges.com/prototypes/available-for-download/websockets).  
  
In this post I will lead you through the process of installing the
WebSockets prototype on your machine. By the end of this tutorial you
should have a working chat web application sample.  
  
**Download**  
  
First you need to
[download](http://html5labs.interoperabilitybridges.com/prototypes/available-for-download/websockets/html5protos_Download)
and run the WebSockets prototype installer.  
  
This package installs the binaries and samples in the
%ProgramFiles%\\Microsoft SDKs\\WCF WebSockets\\10.12.16 folder.  
  
**Enable IIS**  
  
Make sure IIS is enabled on your machine. You can verify this by using
the [Windows feature configuration
tool](http://windows.microsoft.com/en-US/windows-vista/Turn-Windows-features-on-or-off).  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-VerifyIISInstallation.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-VerifyIISInstallation.PNG)  
**Configure the Windows Firewall**  
  
You need to allow incoming TCP traffic on port 4502 in the [Windows
Firewall](http://www.microsoft.com/windows/windows-7/features/windows-firewall.aspx).  
  
Open the Windows Firewall and add a new inbound rule.  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-OpenWindowsFirewall.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-OpenWindowsFirewall.PNG)  
To add a new inbound rule you need to follow the five steps of the
wizard.  
  
First you need to define the type of rule you want to create: Port.  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardPort.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardPort.PNG)  
The protocol you need to use is TCP and the specific port you want to
open is 4502.  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardProtocol.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardProtocol.PNG)  
When connections are attempted through the port we specified, they
should be allowed.  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardConnectionAllow.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardConnectionAllow.PNG)  
This rule should always be applied (for me).  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardProfile.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardProfile.PNG)  
Finalize the wizard by specifying a name for the rule.  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardName.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-RuleWizardName.PNG)  
**Deploy the client access policy**  
  
Copy the %ProgramFiles%\\Microsoft SDKs\\WCF
WebSockets\\10.12.16\\bin\\clientaccesspolicy.xml file to the
%SystemDrive%\\inetpub\\wwwroot folder.  
  
Make sure the file is accessible by navigating to
<http://localhost/clientaccesspolicy.xml>.  
  
**Start the ChatService**  
  
Start %ProgramFiles%\\Microsoft SDKs\\WCF
WebSockets\\10.12.16\\bin\\ChatService.exe.  
  
Because the ChatService assembly is [delay
signed](http://msdn.microsoft.com/en-us/library/t07a3dye(v=vs.80).aspx),
and not fully signed, it will throw an unhandled
System.Security.SecurityException: Strong name validation failed.  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-SecurityException.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-SecurityException.PNG)  
To turn off strong name signing for this assembly you can use
[sn.exe](http://msdn.microsoft.com/en-us/library/k5b5tt23(v=vs.71).aspx).
Execute the following command:  

> sn -Vr "%ProgramFiles%\\Microsoft SDKs\\WCF
> WebSockets\\10.12.16\\bin\\ChatService.exe"

  
**Pay attention:**

-   The command arguments are case sensitive. It's -Vr.
-   If you are running a 64 bit OS you have to use the 64 bit version of
    the tool. I used the Visual Studio x64 Win64 Command Prompt (2010).
-   If you are using the Visual Studio Command Prompt you need to run it
    as an administrator.

  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-VSCommandPromptSN.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-VSCommandPromptSN.PNG)  
Once these problems are fixed, you can finally start the ChatService.  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-StartChatService.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-StartChatService.PNG)  
**Deploy the Chat web application**  
  
[Create a chat virtual directory in
IIS](http://support.microsoft.com/kb/172138) mapped to the
%ProgramFiles%\\Microsoft SDKs\\WCF WebSockets\\10.12.16\\web\\chat
directory.  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-DeployChatIIS.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-DeployChatIIS.PNG)  
**Test the web application**  
  
If you followed all these steps, you should be able to navigate to
<http://localhost/chat/wsdemo.html> and see the results of your efforts.
[Victory](http://www.youtube.com/watch?v=GIeWjLC_SB0)!  
  
[![](../images/thumbnails/2011-01-08-html5-installing-the-microsoft-websockets-prototype-Result.PNG)](../images/2011-01-08-html5-installing-the-microsoft-websockets-prototype-Result.PNG)  
**Problems?**  
  
If you are still facing some problems, feel free to let me know in the
comments.
