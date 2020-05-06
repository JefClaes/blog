+++
title = "HTML5: The Geolocation API is scary (good)"
slug = "2010-12-19-html5-the-geolocation-api-is-scary-good"
published = 2010-12-19T17:30:00.001000+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2010/12/html5-geolocation-api-is-scary-good.html"
+++
I read about the [HTML5 Geolocation API](http://dev.w3.org/geo/api/spec-source.html) in the [Pro HTML5 Programming](http://www.amazon.com/gp/product/1430227907?ie=UTF8&tag=diofanedebyje-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1430227907) book a while ago, and decided to play with it on this lazy Sunday.  
  
Using the Geolocation API to make a one-shot position request is very
straight-forward. Get a reference to the `navigator.geolocation` object
and call the `getCurrentPosition()` method, passing in at least a
`PositionCallback`. In this example I'm also passing in a
`PositionErrorCallback`. In the `PositionCallback` you can examine the
properties of the `position` object. Here I am only using the `latitude` and `longitude` properties.  
  
```js
function showLocation() {                       
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(onSuccess, onError);
    } else {
        var content = document.getElementById("content");        
        content.innerHTML = "Geolocation is not supported by your browser!";
    }                
}
    
function onSuccess(position){
    var content = document.getElementById("content");        
    content.innerHTML = position.coords.latitude + ", " + position.coords.longitude;
}

function onError(error){
    var content = document.getElementById("content");        
    content.innerHTML = "Something went wrong..";
}
```

That's really easy, right? 
  
### The scary part  
  
The privacy part isn't that scary, because the specs state that browsers
must acquire permissions through a user interface. The scary part is,
that it really works and is very accurate even though I'm on a desktop
with no known hotspots nearby! After getting the results, I pasted them
in [Google Maps](http://maps.google.com/) and they were only a few
meters off. Why is it that while most geolocation services have been
failing over the years, it suddenly works this good?  
  
There is some documentation out there, but this documentation is very
simplistic and doesn't touch the internals.  
  
The [Pro HTML5 Programming book](http://www.amazon.com/gp/product/1430227907?ie=UTF8&tag=diofanedebyje-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1430227907) lists which sources can be used.  

> A device can use any of the following sources:  
>
> -   IP address
> -   Coordinate triangulation:
>     - Global Positioning System (GPS)
>     - Wi-Fi with MAC addresses from RFID, Wi-Fi and Bluetooth
>     - GSM or CDMA cell phone IDs
> -   User defined

[FireFox](http://www.mozilla.com/en-US/firefox/geolocation/) lets the
Google Location Services assist them.  

> If you consent, Firefox gathers information about nearby wireless
> access points and your computer’s IP address. Then Firefox sends this
> information to the default geolocation service provider, Google
> Location Services, to get an estimate of your location. That location
> estimate is then shared with the requesting website.