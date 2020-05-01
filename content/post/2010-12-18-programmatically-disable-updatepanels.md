+++
title = "Programmatically disable UpdatePanels"
slug = "2010-12-18-programmatically-disable-updatepanels"
published = 2010-12-18T14:30:00.002000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET", "Tips",]
+++
In this post I'll show you how to programmatically disable all
[UpdatePanels](http://msdn.microsoft.com/en-us/library/system.web.ui.updatepanel.aspx)
in a page. I don't know in which scenario you would want to use this,
but I had to use it to hack around an issue with the ReportViewer
control. I'll save you the details, really.  
  
To disable all the UpdatePanels, you need to set the
[EnablePartialRendering](http://msdn.microsoft.com/en-us/library/system.web.ui.scriptmanager.enablepartialrendering.aspx)
property of the
[ScriptManager](http://msdn.microsoft.com/en-us/library/bb344905.aspx)
to false. You can get a reference to the current ScriptManager by using
the
[GetCurrent()](http://msdn.microsoft.com/en-us/library/system.web.ui.scriptmanager.getcurrent.aspx)
method passing in a reference to the current page.  

    protected void Page_Init(object sender, EventArgs e) {
        ScriptManager.GetCurrent(this.Page).EnablePartialRendering = false;
    }

There is one gotcha: you need to set this property on the
[Page\_Init](http://msdn.microsoft.com/en-us/library/ms178472.aspx)
event, otherwise an
[InvalidOperationException](http://msdn.microsoft.com/en-us/library/system.invalidoperationexception.aspx)
gets thrown.
