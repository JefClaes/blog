+++
title = ".NET API for PasteHTML"
slug = "2010-06-20-net-api-for-pastehtml"
published = 2010-06-20T16:10:00.005000+02:00
author = "Jef Claes"
tags = [ ".NET",]
+++
[PasteHTML](http://pastehtml.com/) is a website which lets you upload
and share HTML pages. It's free, anonymous and without registration. The
uploaded pages should stay online <span
style="font-style: italic;">forever</span>.  
  
The only drawback is that you can't edit or delete your uploaded pages
in an easy way <span style="font-style: italic;">yet</span>. It is ad
free, but I guess there will be some advertisements in the future when
hosting costs increase.  
  
You can make a POST request to upload a page through their [public
API](http://pastehtml.com/help/api). I made an API for .NET which
encapsulates building the url, making the request and parsing the
response. This API makes uploading pages to PasteHtml through your own
website or program child's play.  
  
<span style="font-weight: bold;">Example</span>  
  

       1:  PasteHtmlClient client = new PasteHtmlClient();

       2:   

       3:  PasteHtmlRequest req = new PasteHtmlRequest()

       4:  {

       5:       InputType = PasteHtmlInputType.Html,

       6:       Text = @"<div class='box'> 

       7:                <h3>The standard Lorem Ipsum passage, used since the 1500s</h3> 

       8:                <p>Lorem ipsum dolor sit amet, consectetur..</p>

       9:                </div>"

      10:  };

      11:   

      12:  PasteHtmlResponse resp = client.PasteHtml(req);            

      13:              

      14:  System.Console.WriteLine(resp.Url);

      15:  System.Console.ReadKey();           

  
In this example the PasteHtmlResponse.Url property returned
http://pastehtml.com/view/19tfe0n.html.  
  
<span style="font-weight: bold;">Assemblies, source and your
opinion!</span>  
  
<s>You can download the API's Alpha version here. Play with it, take a
look at the source and let me know what you think!</s>  
  
<span style="font-weight: bold;">Update (22/10/2010):</span> Fixed the
download.  
<span style="font-weight: bold;">Update (24/07/2011):</span> The project
is now on Github!  
**Update (04/20/2018):** This project is dead.
