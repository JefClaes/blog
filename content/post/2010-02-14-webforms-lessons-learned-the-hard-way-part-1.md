+++
title = "Webforms lessons learned the hard way (Part 1)"
slug = "2010-02-14-webforms-lessons-learned-the-hard-way-part-1"
published = 2010-02-14T16:22:00+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "Ramblings", "Best Practices",]
+++
I've been spending a lot of my days in Webforms the last two years. In
this post I want to share some best practices I've learned the hard way
over these years. A lot of MVC developers might think this post comes a
bit late (who still cares about Webforms?!), I do think (in the real
world) a lot of the ASP.NET developers are still using Webforms. This
post is directly targeting them.  
  
<span style="font-weight:bold;">Keep your pages light</span>  
  
There are a few things where you should pay attention to.  
  
Most of the times the
[Viewstate](http://msdn.microsoft.com/en-us/library/ms972976.aspx) is
the number one performance killer. Although most developers know storing
a lot of ViewState on the page has issues, and that there are numerous
[alternatives](http://www.eggheadcafe.com/articles/20040613.asp). Most
developers don't take the time to think about the Viewstate. I don't
blame them. Persisting the ViewState to another medium is not as easy as
it should be. The Viewstate is enabled by default, disabling the
Viewstate on each control is a hassle.. In ASP.NET 4 the
[ViewStateMode](http://jclaes.blogspot.com/2009/12/problem-that-viewstatemode-solves.html)
will make it much easier though. Once the users start complaining about
performance, you are too late. I really encourage you to start thinking
about the Viewstate as early as possible. Only use it when you need to
persist changes across Postbacks. You will be surprised how little you
really need to persist.  
  
A [Masterpage](http://msdn.microsoft.com/en-us/library/wtxbf3hh.aspx) is
great for applying a consistent style to your pages. But be careful with
what you put in the head tag of your Masterpage. Often you only need a
certain stylesheet or javascript library in a few pages. Avoid including
references to these stylesheets and javascript libraries in your
Masterpage. Better is to put a
[ContentPlaceHolder](http://msdn.microsoft.com/en-us/library/system.web.ui.webcontrols.contentplaceholder.aspx)
in the head tag of your Masterpage and use that for your conditional
resources.  
  
[Updatepanels](http://www.asp.net/Ajax/Documentation/Live/overview/UpdatePanelOverview.aspx)
are great controls, but you should apply them wisely. Don't blindly wrap
your whole form in an Updatepanel. Think about which part of your page
really needs to be refreshed. The less HTML and ViewState (!) coming
back from the server the better.  
  
Use javascript. I think to many Webforms developers are uncomfortable
leaving their serverside habitat. Avoid a postback whenever you can.
That's one of the rules I try to apply.  
  
<span style="font-weight:bold;">Stay away from the designer</span>  
  
Creating pages using the designer doesn't work on so many levels.  
  
The Design view doesn't always give a correct representation of how the
page will look like when it's rendered by the browser.  
  
Using drag-and-drop, databinding wizards.. does not end well. I have a
big problem with defining
[datasources](http://www.beansoftware.com/asp.net-tutorials/data-source-controls.aspx)
in the ASPX markup. In my opinion the ASPX markup should be as clean as
possible. It should serve as a view, and as a view only. Another
downside of defining your datasources in your ASPX markup is that your
application tends to be more fragile.  
  
Let me prove this by this example..  
  
In this example I'm binding a List of FireStationEvents to a GridView.
Notice the TypeName and SelectMethods are strings.  

  

       1:  <form id="form1" runat="server">

       2:      <div>           

       3:          <asp:GridView ID="gvEvents" runat="server" DataSourceID="odsEvents">

       4:          </asp:GridView>        

       5:      </div>

       6:      <asp:ObjectDataSource ID="odsEvents" runat="server" 

       7:          SelectMethod="Load" 

       8:          TypeName="WFDemo.BusinessLogic.FireStationEvents">

       9:      </asp:ObjectDataSource>

      10:  </form>

  

  
A few weeks later I decide to change the methodname Load to LoadAll. I
rebuild and all is good. I publish my site to production, and a few
hours later I get a critical bugreport assigned to me. After looking
into it, I discover I forgot to change the SelectMethod property of the
DataSource. Loading the page throws an unhandled Exception at runtime:
ObjectDataSource 'odsEvents' could not find a non-generic method 'Load'
that has no parameters. One small refactoring made the application fail
big time and I didn't even have a clue.  
  
Stay posted for Part 2 tomorrow! What are some of your Webforms lessons
learned the hard way?
