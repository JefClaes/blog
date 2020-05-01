+++
title = "Visualizing the offline application cache update progress"
slug = "2012-04-11-visualizing-the-offline-application-cache-update-progress"
published = 2012-04-11T16:27:00.001000+02:00
author = "Jef Claes"
tags = [ "javascript", "Browsers", "HTML5",]
+++
I wrote about using the HTML5 application cache
[earlier](http://jclaes.blogspot.com/2012/03/html5-offline-web-applications-as.html),
mostly focusing on generating and serving the manifest file using
ASP.NET MVC. I also bitched about how [not one browser I know of gives
an indication of the application cache update
progress](http://jclaes.blogspot.com/2012/03/how-web-application-can-download-and.html).
Today I wanted to write something about how you can visualize the
application cache update progress yourself.  
  
The applicationCache API has several useful and rather straightforward
events we can handle to inform the user of the update progress.  

    window.applicationCache.onchecking = function (e) {
        updateCacheStatus('Checking for a new version of the application.');
    };
    window.applicationCache.ondownloading = function (e) {
        updateCacheStatus('Downloading a new offline version of the application');
    };
    window.applicationCache.oncached = function (e) {
        updateCacheStatus('The application is available offline.');
    };
    window.applicationCache.onerror = function (e) {
        updateCacheStatus('Something went wrong while updating the offline version 
                            of the application. It will not be available offline.');
    };
    window.applicationCache.onupdateready = function (e) {
        window.applicationCache.swapCache();
        updateCacheStatus('The application was updated. Refresh for the changes to take place.');
    };
    window.applicationCache.onnoupdate = function (e) {
        updateCacheStatus('The application is also available offline.');
    };
    window.applicationCache.onobsolete = function (e) {
        updateCacheStatus('The application can not be updated, no manifest file was found.');
    };

One event that is particularly helpful is the progress event. This event
fires every time a resource is downloaded and contains three useful
attributes we can use to display the download progress:
lengthComputable, loaded and total. These attributes should be fairly
self-descriptive, but here is the relevant snippet of [the W3C
specificiations](http://www.w3.org/TR/2011/WD-html5-20110525/offline.html).  

> For each cache host associated with an application cache in cache
> group, queue a post-load task to fire an event with the name progress,
> which does not bubble, which is cancelable, and which uses the
> ProgressEvent interface, at the ApplicationCache singleton of the
> cache host. The lengthComputable attribute must be set to true, the
> total attribute must be set to the number of files in file list, and
> the loaded attribute must be set to the number of number of files in
> file list that have been either downloaded or skipped so far. The
> default action of these events must be, if the user agent shows
> caching progress, the display of some sort of user interface
> indicating to the user that a file is being downloaded in preparation
> for updating the application. 

To have a text that updates the percentage of downloaded resources on
every download, I came up with this.  

    window.applicationCache.onprogress = function (e) {               
        var message = 'Downloading offline resources.. ';

        if (e.lengthComputable) {
            updateCacheStatus(message + Math.round(e.loaded / e.total * 100) + '%');
        } else {
            updateCacheStatus(message);
        };
    };

These attributes seem to be implemented in WebKit browsers, but not in
Firefox. Firefox will fall back to the static message 'Downloading
offline resources..'. Internet Explorer doesn't support the offline
application cache as a whole.  
  
I'm sure more creative souls have it in them to build a really elegant
and visually pleasing progress indication using this technique. I'm
curious to hear (or **see**!) how you would represent the update
process.
