+++
title = "Using JSON serialization outside a web context"
slug = "2011-02-06-using-json-serialization-outside-a-web-context"
published = 2011-02-06T16:00:00+01:00
author = "Jef Claes"
tags = [ ".NET", "javascript", "jQuery",]
+++
You usually are in a web context if you are working with
[JSON](http://www.json.org/), where JSON serialization almost always is
encapsulated by the framework. You might accidentally come across
scenarios where you want to serialize and deserialize JSON in a non-web
context though.  
  
Turns out this is fairly trivial since .NET 3.5. .NET 3.5 added the
[JavaScriptSerializer](http://msdn.microsoft.com/en-us/library/system.web.script.serialization.javascriptserializer.aspx)
class. You can find this class in the
[System.Web.Script.Serialization](http://msdn.microsoft.com/en-us/library/system.web.script.serialization.aspx)
namespace. To access this namespace you need to reference the
System.Web.Extensions assembly.  
  
From there on out, JSON serialization is very straightforward.  
  
In this example I'm serializing and deserializing a Robot object.  
  

       1:  public class Robot {

       2:      public string Name { get; set; }

       3:      public string Position { get; set; }

       4:      public string HomeWorld { get; set; }

       5:   

       6:      public override string ToString() {

       7:          return string.Format("{0} ({1}) from {2}.", new object[] {Name, Position, HomeWorld});

       8:   

       9:      }

      10:  }

  
**From object to JSON string**  
  

       1:  var robot = new Robot() {

       2:      Name = "R2-D2",

       3:      Position = "Astromech droid",

       4:      HomeWorld = "Naboo"

       5:  };

       6:   

       7:  var javascriptSerializer = new JavaScriptSerializer();

       8:  var robotAsJson = javascriptSerializer.Serialize(robot);

       9:   

      10:  Console.WriteLine("Robot as JSON: " + robotAsJson);

      11:  //Robot as JSON: {"Name":"R2-D2","Position":"Astromech droid","HomeWorld":"Naboo"}

  
**From JSON string to object**  
  

       1:  var robotFromJson = javascriptSerializer.Deserialize<Robot>(robotAsJson);

       2:   

       3:  Console.WriteLine("Robot as object: " + robotFromJson);

       4:  //Robot as object: R2-D2 (Astromech droid) from Naboo.

  
If you are looking for a way to use JSON serialization in a web context,
you might want to read these articles:

-   [WCF and JSON
    Services](http://www.west-wind.com/weblog/posts/164419.aspx)
-   [MVC
    JSON](http://geekswithblogs.net/michelotti/archive/2008/06/28/mvc-json---jsonresult-and-jquery.aspx)
-   [ASMX 2.0 Services and
    JSON](http://randomactsofcoding.blogspot.com/2009/03/jquery-json-and-asmx-20-services.html)
