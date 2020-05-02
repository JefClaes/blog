+++
title = "Angular.js and IE8 caching"
slug = "2013-06-09-angular-js-and-ie8-caching"
published = 2013-06-09T16:52:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2013/06/angularjs-and-ie8-caching.html"
+++
Older Internet Explorer versions are notorious for agressively caching
AJAX requests. In this post, you'll find two techniques that combat this
behaviour.  
  
The first option is to have your server explicitly set the caching
headers.  

```csharp
Response.Cache.SetExpires(DateTime.UtcNow.AddDays(-1));
Response.Cache.SetValidUntilExpires(false);
Response.Cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
Response.Cache.SetCacheability(HttpCacheability.NoCache);
Response.Cache.SetNoStore();
```

Since you don't necessarily own the server, or clients might already
have cached some requests, you can trick the browser into thinking each
request is a fresh one by making each url unique. Our old pal jQuery
already learned [this
trick](http://stackoverflow.com/questions/4303829/how-to-prevent-jquery-ajax-caching-in-internet-explorer)
years ago. Angular.js on the other hand seems to have forgotten. We can
get around though.  
  
If you merge <span id="goog_2113062658"></span>[this pull
request](https://github.com/angular/angular.js/pull/2130) <span
id="goog_2113062659"></span>(or wait for angular.js version 1.2), you
will find angular's HTTP provider augmented with request interceptors,
enabling you to mold the request before it goes out.  
  
The interceptor we're adding to kill the cache only touches GET
requests, appending a 'cacheSlayer' querystring parameter with a
timestamp to each url, making it unique and thus bypassing the cache. A
factory is responsible for creating it, while a config block pushes it
into a collection of interceptors.

```js
var AppInfrastructure = angular.module('App.Infrastructure', []);

AppInfrastructure
    .config(function ($httpProvider) {
        $httpProvider.requestInterceptors.push('httpRequestInterceptorCacheBuster');
    })    
    .factory('httpRequestInterceptorCacheBuster', function () {
        return function (promise) {
            return promise.then(function (request) {
                if (request.method === 'GET') {
                    var sep = request.url.indexOf('?') === -1 ? '?' : '&';
                    request.url = request.url + sep + 'cacheSlayer=' + new Date().getTime();
                }

                return request;
            });
        };
    });    
```

I hope this helps someone spending time on more important matters.
