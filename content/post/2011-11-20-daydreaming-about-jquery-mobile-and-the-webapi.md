+++
title = "Daydreaming about jQuery Mobile and the WebAPI"
slug = "2011-11-20-daydreaming-about-jquery-mobile-and-the-webapi"
published = 2011-11-20T17:24:00.001000+01:00
author = "Jef Claes"
tags = [ "ASP.NET", "javascript", "Ramblings", "jQuery",]
+++
I recently blogged about [programming for the future of
mobile](http://jclaes.blogspot.com/2011/11/programming-for-future-of-mobile.html)
with [jQuery Mobile](http://jquerymobile.com/) and the
[WebAPI](https://wiki.mozilla.org/WebAPI). You probably heard that
jQuery Mobile 1.0 was released earlier this week. Although it will take
a while before we will see some actual results from the WebAPI
initiative, that shouldn't keep us from letting our minds play with
things that might be possible one day using the WebAPI.  
  
The thoughts in this post were provoked by an interesting comment
[Kristof Claes](http://www.kristofclaes.be/) left on my previous post.  

> One thing I don't like about jQuery Mobile is that it has this iPhony
> (pun not intended) look to it.  
>   
> I have a WP7 device and for some reason I don't want applications to
> look like I'm using an iPhone. I can imagine the average iPhone user
> wouldn't be happy when jQuery Mobile used a Metro-like skin.

And I agree, it does look iPhony. Although there already is a
themeroller for jQuery mobile, it's limited to changing the color
scheme. Like Kristof said, the contrast between the Metro UI and the
jQuery Mobile UI is enormous.  
  
Platform specific themes might help to close that gap. I really think
this makes sense for mobile, because - compared to desktops - most
mobile operating systems do leverage a signifantly different feel. Also,
the browser is full screen on most mobile devices, saving space, but
also losing the native OS context.  
  
I have been thinking a bit about how this could be implemented. So
follow along, and let me know if these ramblings seem feasible.  
  
Serving themes based on the operating system should be doable. A naïve
implementation, which only supports Metro, could be as simple as this.  

    return Request.UserAgent.Contains("Windows Phone OS 7.5") ? "jQueryMobile.Metro.css" : "jQueryMobile.Default.css";            

On my Windows Phone, I can configure the background- and the accent
color for the Metro UI. And this is where it gets interesting. Using the
[SettingsAPI](https://wiki.mozilla.org/WebAPI/SettingsAPI), defined in
the WebAPI standards, we might be able to find out those values in our
webapplication. Meaning we could make the mobile UI 'experience'
completely transparant.  
  
The proposed Settings API standard looks like this.  
  

    interface SettingsManager

    {

        // List of known settings.

        const DOMString FOOBAR = "foobar";

     

        // Setters. SettingsRequest.result is always null.

        SettingsRequest set(DOMString name, DOMString value);

        SettingsRequest set(DOMString name, long value);

        SettingsRequest set(DOMString name, long long value);

        SettingsRequest set(DOMString name, float value);

     

        // Getters. SettingsRequest.result will be of the requested type if the success event is sent.

        SettingsRequest getString(DOMString name);

        SettingsRequest getInt(DOMString name);

        SettingsRequest getLong(DOMString name);

        SettingsRequest getFloat(DOMString name);

    }

  
So, dynamically modifying the css to comply to the Metro color sheme
could be this easy.  
  

    var backgroundColorRequest = settingsManager.getString('metro-backgroundColor');

    backgroundColorRequest.onSuccess = function() {

        $(".main").css("background-color", this.result);

    }

    var accentColorRequest = settingsManager.getString('metro-accentColor');

    accentColorRequest.onSuccess = function() {

        $(".tile").css("background-color", this.result);

    };

  
Is it just me, or does the WebAPI have some sick potential?
