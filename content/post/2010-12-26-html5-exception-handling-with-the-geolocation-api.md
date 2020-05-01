+++
title = "HTML5: Exception handling with the Geolocation API"
slug = "2010-12-26-html5-exception-handling-with-the-geolocation-api"
published = 2010-12-26T20:30:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "javascript", "Browsers",]
+++
In [my previous
post](http://jclaes.blogspot.com/2010/12/html5-geolocation-api-is-scary-good.html)
on the [Geolocation API](http://dev.w3.org/geo/api/spec-source.html) I
passed in a PositionErrorCallback to the
[geolocation.getCurrentPosition()](http://dev.w3.org/geo/api/spec-source.html#geolocation_interface)
method. When I received this callback I displayed a generic message
informing the user something went wrong. In real-world scenarios you
probably want the message to be more specific. You might also want to
call a specific fallback method depending on what went wrong.  
  
This is where the
[PositionError](http://dev.w3.org/geo/api/spec-source.html#position_error_interface)
argument of the PositionErrorCallback comes in handy. This object has
two properties: code and message.  
  
The code property can return three codes:

-   1: PERMISSION\_DENIED
-   2: POSITION\_UNAVAILABLE
-   3: TIMEOUT

The message property returns a string describing what went wrong. Be
careful, this property is primarily intended for debugging!  
  
**Example**  
  
The codesnippet below only shows the part where I am handling the
PositionErrorCallback. You can find the demo and full source
[here](http://pastehtml.com/view/1cirxou.html).  
  

    function onError(error){

        var content = document.getElementById("content");        

        var message = "";

        

        switch (error.code) {

            case 0:

                message = "Something went wrong: " + error.message;

                break;

            case 1:

                message = "You denied permission to this page to retrieve a location.";

                break;

            case 2:

                message = "The browser was unable to determine a location: " + error.message;

                break;

            case 3:

                message = "The browser timed out before retrieving the location.";

                break;

        }

        

        content.innerHTML = message;

    }
