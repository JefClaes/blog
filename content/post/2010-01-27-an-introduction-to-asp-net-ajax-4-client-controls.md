+++
title = "An introduction to ASP.NET Ajax 4: Client Controls"
slug = "2010-01-27-an-introduction-to-asp-net-ajax-4-client-controls"
published = 2010-01-27T07:37:00.001000+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "AJAX",]
+++
Client Controls are controls from the [Ajax Control
Toolkit](http://www.asp.net/(S(fu2l2uzphr2u3u45q2dnez55))/ajax/AjaxControlToolkit/Samples/)
made available client-side.  
  
This means you can now use these awesome controls without using ASP.NET
WebForms.  
  
You can instantiate these controls
[imperatively](http://www.asp.net/ajaxLibrary/HOW%20TO%20Instantiate%20Controls%20Imperatively.ashx),
[declaratively](http://www.asp.net/ajaxLibrary/HOW%20TO%20Instantiate%20Controls%20Declaratively.ashx)
or imperatively with [jQuery](http://jquery.com/). All controls are
exposed as [jQuery](http://jquery.com/) plugins automatically.  
  
You can find these controls in the ExtendedControls script.  
  
<span style="font-weight:bold;">Example</span>  
  
This example shows you how to hook a color picker to an input element
using [jQuery](http://jquery.com/) and the ExtendedControls.  
  

  

       1:  <html xmlns="http://www.w3.org/1999/xhtml" >  

       2:  <head>  

       3:      <title>Demo - Client Controls</title>  

       4:      <!--Styles-->   

       5:      <link rel="Stylesheet" type="text/css" href="http://ajax.microsoft.com/ajax/beta/0911/extended/colorpicker/colorpicker.css" />            

       6:      <!--Scripts-->

  

       7:      <script src="http://ajax.microsoft.com/ajax/beta/0911/Start.debug.js" type="text/javascript"></script>    

       8:      <script src="http://ajax.microsoft.com/ajax/beta/0911/extended/ExtendedControls.debug.js" type="text/javascript"></script>       

       9:      <script src="http://ajax.microsoft.com/ajax/jquery/jquery-1.3.2.js" type="text/javascript"></script>          

      10:      <script type="text/javascript">

      11:          Sys.Debug = true;

      12:   

      13:          Sys.onReady(function(){        

      14:              Sys.require(Sys.components.colorPicker, function () {

      15:              $("#colorPicker").colorPicker({});

      16:              });            

      17:          });        

      18:      </script>  

      19:  </head>  

      20:  <body>  

      21:      <div>  

      22:          <form id="form1" action="/">

      23:          <div><input type="text" id="colorPicker" /></div>                                                 

      24:          </form>

      25:      </div>  

      26:  </body>  

      27:  </html>  

  

  
  
[![](../images/thumbnails/2010-01-27-an-introduction-to-asp-net-ajax-4-client-controls-colorpicker.JPG)](../images/2010-01-27-an-introduction-to-asp-net-ajax-4-client-controls-colorpicker.JPG)
