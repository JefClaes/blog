+++
title = "Building a tagcloud with jQuery and ASMX Webservices"
slug = "2010-09-18-building-a-tagcloud-with-jquery-and-asmx-webservices"
published = 2010-09-18T18:00:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET", "javascript", "jQuery",]
+++
Generating tagclouds is nothing new. People have been generating
[tagclouds
server-side](http://www.4guysfromrolla.com/articles/102506-1.aspx) since
the seventies. Lately more and more tagclouds are being generated
client-side.  
  
There is nothing wrong with generating tagclouds server-side. Telerik
has a great [tagcloud server
control](http://demos.telerik.com/aspnet-ajax/tagcloud/examples/overview/defaultcs.aspx).
Generating tagclouds server-side can bring some overhead though, so
depending on the scenario and the requirements you might decide to do it
client-side. There are a ton of fancy ready-to-use jQuery [tagcloud
plug-ins](http://www.dreamcss.com/2009/05/jquery-and-ajax-based-tag-cloud.html)
out there. None of them met my requirements perfectly, so I decided to
do it myself.  
  
In this post you can find my own implementation. It's simple,
straightforward and a decent base to start experimenting yourself.  
  
<span style="font-weight:bold;">Making the tags available through an
ASMX Webservice</span>  
  
In my implementation I use an ASMX Webservice to expose a TagCollection.
The TagCollection is an object which contains a List&lt;Tag&gt;. The
TagCollection also has a MaxWeight property which we will need on the
client-side to calculate the relative weight.  
  

       1:  public class TagCollection {

       2:      public TagCollection() { }

       3:   

       4:      public TagCollection(List<Tag> items, int maxWeight) {

       5:          this.Items = items;

       6:          this.MaxWeight = maxWeight;

       7:      }

       8:   

       9:      public List<Tag> Items { get; set; }

      10:      public int MaxWeight { get; set; }

      11:  }

  
  
A Tag is a simple object with two properties: Value and Weight.  
  

       1:  public class Tag {

       2:      public Tag() { }

       3:   

       4:      public Tag(string value, int weight) {

       5:          this.Value = value;

       6:          this.Weight = weight;

       7:      }

       8:   

       9:      public string Value { get; set; }

      10:      public int Weight { get; set; }

      11:  }

  
  
In the ASMX WebService I created the GetTagCollection method which
returns a TagCollection. Don't forget to uncomment the
[\[System.Web.Script.Services.ScriptService\]](http://msdn.microsoft.com/en-us/library/system.web.script.services.scriptserviceattribute.aspx)
declaration and to add the [\[ScriptMethod(ResponseFormat =
ResponseFormat.Json)\]](http://msdn.microsoft.com/en-us/library/system.web.script.services.scriptmethodattribute.aspx)
declaration to the GetTagCollection method.  
  

       1:  [WebService(Namespace = "http://TagCloudWithJquery.com")]

       2:  [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]

       3:  [System.Web.Script.Services.ScriptService]

       4:  public class TagService : System.Web.Services.WebService { 

       5:      [WebMethod]

       6:      [ScriptMethod(ResponseFormat = ResponseFormat.Json)]

       7:      public TagCollection GetTagCollection() {

       8:          var items = new List<Tag>() {

       9:                  new Tag(".NET", 20),

      10:                  new Tag("CodeSnippets", 15),

      11:                  new Tag("...", 10),

      12:                  new Tag("ASP.NET", 18)                

      13:              };

      14:          var maximumWeight = items.Max(i => i.Weight);

      15:   

      16:          var tagCollection = new TagCollection(items, maximumWeight);        

      17:   

      18:          return tagCollection;

      19:      }

      20:  }

  
  
<span style="font-weight:bold;">Consuming the ASMX Webservice</span>  
  
Consuming the ASMX Webservice with jQuery is relatively simple. If you
are new to consuming ASMX Webservices with jQuery, I advice you to read
[this excellent
article](http://encosia.com/2008/03/27/using-jquery-to-consume-aspnet-json-web-services/).  
  
When the document is ready I make a call to the ASMX Webservice and when
the call is successful all the work gets passed to the onTagCloudSuccess
function.  
  

       1:  $(document).ready(setupTagCloud);

       2:   

       3:  function setupTagCloud() {

       4:      $.ajax({

       5:          type: "POST",

       6:          contentType: "application/json; charset=utf-8",

       7:          url: "Services/TagService.asmx/GetTagCollection",

       8:          data: "{}",

       9:          dataType: "json",

      10:          success: onTagCloudSuccess

      11:      });

      12:  }

  
  
Don't forget to add a script reference to [the latest version of
jQuery](http://code.jquery.com/jquery-1.4.2.min.js).  
  
<span style="font-weight:bold;">Generating the tagcloud</span>  
  
All the work happens in the onTagCloudSuccess function. In this function
I iterate over all the items in the TagCollection. For each item I
calculate its relative weight using the TagCollections MaxWeight
property. Depending on the relative weight the tag gets a different css
class. This logic can be found in the getCloudItemClass function.  
  
Finally I append a new listitem to the unordered list 'items' using the
tags value and the calculated css class.  
  

       1:  function onTagCloudSuccess(data, textStatus) {      

       2:      var maxWeight = data.d.MaxWeight;

       3:   

       4:      $.each(data.d.Items, function(i, item) {

       5:          var itemWeight = item.Weight;

       6:          var relativeItemWeight = itemWeight / maxWeight;

       7:          var itemClass = getCloudItemClass(relativeItemWeight);            

       8:   

       9:          $("#items").append("<li class='" + itemClass + "'>" + item.Value + "</li>");

      10:      });       

      11:  }

      12:   

      13:  function getCloudItemClass(weight) {

      14:      if (weight < 0.35) {

      15:          return "light";

      16:      } else if (weight < 0.7) {

      17:          return "medium";

      18:      } else {

      19:          return "heavy";

      20:      }       

      21:  }

  
  
Don't forget to add an unordered list with the id set to 'items' to your
page.  
  
So far this looks something like this.  
  
[![](../images/thumbnails/2010-09-18-building-a-tagcloud-with-jquery-and-asmx-webservices-noCss.PNG)](../images/2010-09-18-building-a-tagcloud-with-jquery-and-asmx-webservices-noCss.PNG)  
  
I used following css to make the unordered list look like a tagcloud.  
  

       1:  #items li {               

       2:      display: inline-block;         

       3:      margin: 4px;

       4:  }

       5:   

       6:  .heavy { font-size: 60px ; color:Red; }

       7:  .medium { font-size: 30px; color:Orange; }

       8:  .light { font-size: 14px ; color:Yellow; }

  
  
Setting the display to inline-block on the listitems makes the unordered
list go horizontal instead of vertical. The heavy, medium and light
classes are used to give the tagclouditems a style that matches with
their heaviness.  
  
The final result looks like this.  
  
[![](../images/thumbnails/2010-09-18-building-a-tagcloud-with-jquery-and-asmx-webservices-tagCloudwithCss.PNG)](../images/2010-09-18-building-a-tagcloud-with-jquery-and-asmx-webservices-tagCloudwithCss.PNG)  
  
Different ways of marking up a tagcloud can be found in [this
article](http://24ways.org/2006/marking-up-a-tag-cloud).  
  
<span style="font-weight:bold;">Get the source</span>  
  
You can find the full source
[here](http://rapidshare.com/files/419802486/TagCloud.rar).  
  
<span style="font-weight:bold;">Feedback</span>  
  
As always I want to hear your feedback. Please tell me how this
implementation can be improved.
