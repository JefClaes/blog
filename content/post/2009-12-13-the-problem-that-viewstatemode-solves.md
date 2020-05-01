+++
title = "The problem that ViewStateMode solves"
slug = "2009-12-13-the-problem-that-viewstatemode-solves"
published = 2009-12-13T16:55:00.004000+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "Tips",]
+++
A new feature of ASP.NET 4.0 is the ViewStateMode property on a
Control.  
  

> You can use the ViewStateMode property to enable view state for an
> individual control even if view state is disabled for the page.  
> [Source:Msdn](http://msdn.microsoft.com/en-us/library/system.web.ui.control.viewstatemode(VS.100).aspx)  

  
In this post I'll try to give this new feature a chance to shine and
show it's use.  
  
<span style="font-weight:bold;">Problem to solve: Disable ViewState on
the Page and enable it on an individual Control.</span>  
  
Let's try to solve this without the ViewStateMode property. Simply
disable the ViewState on the page and enable it on lblViewstate1.  
  

       1:  <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewState_3_5.aspx.cs" Inherits="Demo_2___ViewState.ViewState_3_5" 

       2:      EnableViewState="False"%>

       3:   

       4:  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

       5:   

       6:  <html xmlns="http://www.w3.org/1999/xhtml">

       7:  <head runat="server">

       8:      <title></title>

       9:  </head>

      10:  <body>

      11:      <form id="form1" runat="server">

      12:      <div>

      13:          <asp:Panel runat="server" ID="pnViewState">

      14:              <asp:Label runat="server" Text="[Static value]" ID="lblViewState1" EnableViewState="True"/>

      15:              <asp:Label runat="server" Text="[Static value]" ID="lblViewState2"/>        

      16:              <asp:Button runat="server" Text="Do PostBack" ID="btnDoPostBack" onclick="btnDoPostBack_Click" />

      17:          </asp:Panel>

      18:      </div>

      19:      </form>

      20:  </body>

      21:  </html>

  

       1:  protected void Page_Load(object sender, EventArgs e)

       2:  {

       3:       if (!Page.IsPostBack)

       4:       {

       5:           this.lblViewState1.Text = "[Dynamic value]";

       6:           this.lblViewState2.Text = "[Dynamic value]";

       7:       }

       8:  }

       9:   

      10:  protected void btnDoPostBack_Click(object sender, EventArgs e)

      11:  {

      12:      //Do Postback

      13:  }

  
Hmmm this doesn't work. When I click the button and do a PostBack the
Label lblViewState1 didn't maintain it's state. It displays \[Static
value\] instead of \[Dynamic value\].  
  
You could solve this problem by enabling the ViewState on the Page and
disable the ViewState on all Controls that don't need to maintain their
state. But that's pretty silly right?  
  
This is where the ViewStateMode property comes into play. Check out the
example below. I disable the ViewStateMode on the Page and I enable the
ViewStateMode on lblViewState1.  
  

       1:  <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewState_3_5.aspx.cs" Inherits="Demo_2___ViewState.ViewState_3_5" 

       2:      EnableViewState="True" ViewStateMode="Disabled"%>

       3:   

       4:  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

       5:   

       6:  <html xmlns="http://www.w3.org/1999/xhtml">

       7:  <head runat="server">

       8:      <title></title>

       9:  </head>

      10:  <body>

      11:      <form id="form1" runat="server">

      12:      <div>

      13:          <asp:Panel runat="server" ID="pnViewState">

      14:              <asp:Label runat="server" Text="[Static value]" ID="lblViewState1" ViewStateMode="Enabled"/>

      15:              <asp:Label runat="server" Text="[Static value]" ID="lblViewState2"/>        

      16:              <asp:Button runat="server" Text="Do PostBack" ID="btnDoPostBack" onclick="btnDoPostBack_Click" />

      17:          </asp:Panel>

      18:      </div>

      19:      </form>

      20:  </body>

      21:  </html>

  
After doing a PostBack lblViewState1 still shows \[Dynamic value\] and
lblViewState2 shows \[Static value\]. lblViewState1 maintained it's
state!  
  
This feature gives us another reason to stop being lazy and use
ViewState where it's designed for.  
  
Hope this helps.
