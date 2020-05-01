+++
title = "Check for local file browsing with JavaScript"
slug = "2012-04-02-check-for-local-file-browsing-with-javascript"
published = 2012-04-02T15:34:00+02:00
author = "Jef Claes"
tags = [ "javascript", "Browsers",]
+++
Because I do most of my research while commuting by train, I often pull
entire websites offline using [httrack](http://www.httrack.com/). While
browsing the [jQuery Mobile
documentation](http://jquerymobile.com/demos/1.1.0-rc.1/) locally this
morning, I stumbled upon following gem.  
  

[![](/post/images/thumbnails/2012-04-02-check-for-local-file-browsing-with-javascript-jQueryMobileLocal.PNG)](/post/images/2012-04-02-check-for-local-file-browsing-with-javascript-jQueryMobileLocal.PNG)

  
I was curious to see how they determine whether a page is browsed
locally or not. Looking into the source, I was a bit dissapointed to
find nothing but plain common sense. The trick is comparing the protocol
of the current location with known local protocols.  

    if ( location.protocol.substr(0,4)  === 'file' ||
         location.protocol.substr(0,11) === '*-extension' ||
         location.protocol.substr(0,6)  === 'widget' ) {
        // Disable AJAX support etc
    }

If you would want to use that check in multiple locations in your
codebase, you might want to extend the [location
object](https://developer.mozilla.org/en/DOM/window.location) with an
isLocal function.  

    window.location.constructor.prototype.isLocal = function() { 
        return this.protocol.substr(0,4)  === 'file' || 
                this.protocol.substr(0,11) === '*-extension' || 
                this.protocol.substr(0,6)  === 'widget'; 
    }

The function could be used like this.  

    if (window.location.isLocal()) {
        // Disable AJAX support etc
    }
