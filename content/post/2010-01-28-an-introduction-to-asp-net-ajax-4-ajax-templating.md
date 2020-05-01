+++
title = "An introduction to ASP.NET Ajax 4: Ajax Templating"
slug = "2010-01-28-an-introduction-to-asp-net-ajax-4-ajax-templating"
published = 2010-01-28T08:09:00.001000+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "AJAX",]
+++
ASP.NET Ajax 4 contains a powerful templating engine. The Dataview makes
it very easy to bind [JSON](http://www.json.org/) data to HTML
elements.  
  
You can bind the JSON data to the Dataview imperatively or declaratively
(mapping html elements with javascript).  
  
Some code examples shows best.  
  
<span style="font-weight:bold;">Example (Imperatively)</span>  

  

       1:  <html xmlns="http://www.w3.org/1999/xhtml">

       2:  <head runat="server">

       3:      <title>Demo - Ajax Templating</title>      

       4:      <script src="Scripts/Start.debug.js" type="text/javascript"></script>       

       5:      <!-- Script -->

       6:      <script type="text/javascript">

       7:          Sys.Debug = true;

       8:      

       9:          var events = [

      10:                 { Street: 'Laarsveld', City: 'Geel', Priority: 2 },

      11:                 { Street: 'Noorderlaan', City: 'Antwerpen', Priority: 1 },

      12:                 { Street: 'Meir', City: 'Antwerpen', Priority: 5 },

      13:                 { Street: 'Groenplaats', City: 'Antwerpen', Priority: 1 },

      14:                 { Street: 'Bredabaan', City: 'Antwerpen', Priority: 1 }               

      15:             ];       

      16:                   

      17:          Sys.require(Sys.components.dataView, function(){

      18:              Sys.onReady(function () {

      19:                  Sys.create.dataView("#eventList1", { data: events });                       

      20:              });

      21:           }

      22:          );                      

      23:         </script>  

      24:     </head>  

      25:     <body>  

      26:         <h1>Events</h1>  

      27:         <table>            

      28:              <thead>

      29:                  <tr><th>Street</th><th>City</th><th>Priority</th></tr>

      30:              </thead>

      31:              <tbody id="eventList1" class="sys-template">

      32:                  <tr align="center"><td>{{Street}}</td><td>{{City}}</td><td>{{Priority}}</td></tr>                           

      33:              </tbody>

      34:         </table>                           

      35:     </body>  

      36:  </html>

  
  
<span style="font-weight:bold;">Example (Declaratively)</span>  

  

       1:  <html xmlns="http://www.w3.org/1999/xhtml">

       2:  <head runat="server">

       3:      <title>Demo - Ajax Templating</title>      

       4:      <script src="Scripts/Start.debug.js" type="text/javascript"></script>       

       5:      <!-- Script -->

       6:      <script type="text/javascript">

       7:          Sys.Debug = true;

       8:      

       9:          var events = [

      10:                 { Street: 'Laarsveld', City: 'Geel', Priority: 2 },

      11:                 { Street: 'Noorderlaan', City: 'Antwerpen', Priority: 1 },

      12:                 { Street: 'Meir', City: 'Antwerpen', Priority: 5 },

      13:                 { Street: 'Groenplaats', City: 'Antwerpen', Priority: 1 },

      14:                 { Street: 'Bredabaan', City: 'Antwerpen', Priority: 1 }

      15:             ];

      16:          Sys.require(Sys.components.dataView);         

      17:     </script>  

      18:     </head>  

      19:     <body xmlns:sys="javascript:Sys" xmlns:dataview="javascript:Sys.UI.DataView">  

      20:         <h1>Events</h1>  

      21:         <table>            

      22:              <thead>

      23:                  <tr><th>Street</th><th>City</th><th>Priority</th></tr>

      24:              </thead>

      25:              <tbody id="eventList1" class="sys-template"

      26:                     sys:attach="dataview"

      27:                     dataview:data="{{events}}">

      28:                  <tr align="center"><td>{{Street}}</td><td>{{City}}</td><td>{{Priority}}</td></tr>                           

      29:              </tbody>

      30:         </table>                           

      31:     </body>  

      32:  </html>

  
  
Both ways have the same result.  
  
[![](/post/images/thumbnails/2010-01-28-an-introduction-to-asp-net-ajax-4-ajax-templating-templating.JPG)](/post/images/2010-01-28-an-introduction-to-asp-net-ajax-4-ajax-templating-templating.JPG)
