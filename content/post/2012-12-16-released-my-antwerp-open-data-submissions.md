+++
title = "Released: My Antwerp Open Data submissions"
slug = "2012-12-16-released-my-antwerp-open-data-submissions"
published = 2012-12-16T16:44:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "Tools", ".NET", "Hacking", "javascript", "NancyFx", "Opensource", "Browser", "Tips",]
+++
A little while ago the city of Antwerp released their [Open
Data](http://opendata.antwerpen.be/) initiative, and it included a
meetup where you could show something you built, build something on the
spot, or pitch your ideas. When I first heard of the initiative I had
nothing going on the side, and was looking for something tangible I
could build to try out a few technologies. I couldn't come up with an
original idea, and ended up building two web applications using the Open
Data datasets: Culture Mosaic, and Where to pee in Antwerp?  
Since I was bedridden due to the flu, and my ideas were not that great,
I eventually ended up not going to the meetup, but I figured I would
share some stuff I picked up along the way here.  
  
**Culture Mosaic**  
**  
**The first web application uses the [culture
dataset](http://api.antwerpen.be/v1/infrastructuur/cultuur.json) to
display a masonry of cultural attraction images.  
  

[![](/post/images/thumbnails/2012-12-16-released-my-antwerp-open-data-submissions-antwerp+culre.PNG)](/post/images/2012-12-16-released-my-antwerp-open-data-submissions-antwerp+culre.PNG)

  
The images available vary in size, and some turned out to be quite
large. If I wanted to display all the images at once, I had to make them
smaller; resize them. For this task, I found the
[ImageResizer](http://imageresizing.net/) library [on
Nuget](http://nuget.org/packages/ImageResizer). Although you can
reference remote images using an ImageResizer extension, I chose to
download the images locally, to then resize them and to finally cache
them on disk.  
  
I run these tasks in parallel and wait for all of them to finish, using
the [TPL](http://msdn.microsoft.com/en-us/library/dd537609.aspx).

    private void TryToDownloadAllImages(Culture culture)
    {
        var tasks = new List<Task>();

        foreach (var item in culture.Items)
        {
            var localPath = Path.Combine(_pathConfiguration.ImagesFolderPath, item.ImageName);
            if (!File.Exists(localPath))
                tasks.Add(CreateImageDownloadTask(item.Image, localPath));
        }

        Task.WaitAll(tasks.ToArray());     
    }

Downloading a remote file is straightforward using the
[WebClient](http://msdn.microsoft.com/en-us/library/ez801hhe.aspx)
class. Right after downloading the image, I use the ImageBuilder
singleton to resize the image to a width of 340px.

    private Task CreateImageDownloadTask(string imageUrl, string localPath)
    {
        return Task.Factory.StartNew(() =>
        {
            using (var client = new WebClient())
            {
                try
                {                        
                    client.DownloadFile(imageUrl, localPath);

                    ImageBuilder.Current.Build(
                        localPath, 
                        localPath, 
                        new ResizeSettings("maxwidth=340"));
                }            
                catch (ArgumentException) 
                {
                    // filename malformatted; swallow
                }
            }
        });                    
    }                

Now that I have my resized images, I can render them in my view. This is
[NancyFx](http://nancyfx.org/) with the Razor view engine by the way.

    <div id="loading">
        Loading..
    </div>      
    <div id="container" style="display:none;">
        @foreach (var item in Model.Items)
        {               
           <a href="@item.Url">
              <img src="/Content/images/@item.ImageName" alt="@item.Name" title="@item.Name" />
           </a>             
        }
    </div>

To achieve the masonry effect, I used this [jQuery
plug-in](http://masonry.desandro.com/). The one tricky part here is to
only initialize the effect after all the images have really loaded. For
this, I used the
[imagesLoaded](https://github.com/desandro/imagesloaded) plug-in. 

    $container.imagesLoaded(function () {
        $loading.hide();
        $container.show();
        $container.masonry({
            itemSelector: 'img'
        });
    });

One last thing I wanted, was to center the masonry on screen, but since
I didn't want to use a fixed width, I had to dynamically recalculate the
optimal width each time the window is resized. 

    var setContainerWidth = function (container) {
        var imageWidth = 340;
        var bodyWidth = $("body").width();

        var numberOfImagesNextToEachother = Math.floor(bodyWidth / imageWidth);
        var optimalWidth = (imageWidth * numberOfImagesNextToEachother) + (numberOfImagesNextToEachother * 4);

        container.css("width", optimalWidth + "px");
    };

    $(window).resize(function () {
        setContainerWidth($container);
    });

Since we have the width of the images (340px), we can use trivial math
to calculate the optimal amount of width we can consume.  
  
*You can find the [working bits on
AppHarbor](http://antwerp-culture.apphb.com/). Source is [on
GitHub](https://github.com/JefClaes/Antwerp.Apps.CultureMosaic).*  
  
**Where to pee in Antwerp?**  
**  
**The next application is a mobile web application that uses [the public
toilets
dataset](http://api.antwerpen.be/v1/infrastructuur/openbaartoilet.json)
to show the nearest toilets based on your location.  
  

[![](/post/images/thumbnails/2012-12-16-released-my-antwerp-open-data-submissions-wheretopee.PNG)](/post/images/2012-12-16-released-my-antwerp-open-data-submissions-wheretopee.PNG)

  
I wanted to introduce a constraint client-side of having to work with a
somewhat crooked dataset, that's why I just return the dataset using
Nancy as is.

    public ToiletsModule()
    {
        Get["/Toilets"] = p =>
        {
            var response = Response.AsFile(@"Content\json\toilets.json");
            response.ContentType = "application/json";

            return response;
        };
    }

At the client, I'm using [jQuery Mobile](http://jquerymobile.com/) and
[angular.js](http://angularjs.org/). It had been a while since I had
done something with jQuery Mobile, but this version felt very solid
(compared to the beta versions I played with before). Turns out though,
that to make jQuery Mobile and angular.js play nice, you have to include
the [jQuery Mobile Angular
adapter](https://github.com/tigbro/jquery-mobile-angular-adapter). The
size of all these libraries unminified was a performance hog;
[Cassette](http://www.jefclaes.be/2012/11/nancyfx-and-bundling-with-cassette.html)
to the rescue.  
  
The first thing you do with angular, is defining a module. [A
module](http://docs.angularjs.org/guide/module) instantiates, wires and
bootstraps the application.

    var toiletApp = { };        
    toiletApp.module = angular.module('toiletModule', []);

To separate concerns, and make things testable, angular [lets you define
services](http://docs.angularjs.org/guide/dev_guide.services.creating_services)
for your application using a factory. By using a factory you also make
your service an [injectable
dependency](http://docs.angularjs.org/guide/di) for other parts of your
application.  
I added a toilet service to this module which makes the ajax call, sorts
the results based on nearest by, to eventually make them available to
the caller by invoking a callback. The
[$http](http://docs.angularjs.org/api/ng.$http) dependency is one of
angular's core services that lets you do ajax requests.

    toiletApp.module.factory('toiletService', function ($http, Toilet) {

    return {

        getToilets: function (onSucess, onError, coordinates) {

            $http
                .get('toilets')
                .success(function (data) {

                    var toilets = [];

                    for (var i = 0; i < data.openbaartoilet.length; i++) {
                        var toilet = data.openbaartoilet[i];

                        var ourToilet = new Toilet(
                            toilet.omschrijving,
                            toilet.point_lat,
                            toilet.point_lng,
                            toilet.betalend === "niet betalend" ? false : true,
                            toilet.straat,
                            toilet.huisnummer);

                        toilets.push(ourToilet);
                    }

                    if (coordinates) {

                        toilets.sort(function (a, b) {
                            var aDistance = a.calculateDistance(coordinates);
                            var bDistance = b.calculateDistance(coordinates);

                            if (aDistance < bDistance)
                                return -1;
                            if (aDistance > bDistance)
                                return 1;
                            return 0;
                        });

                    }

                    onSucess(toilets);
                })
                .error(function() { onError() });

        }

    };

You might have noticed the Toilet dependency; into this class I project
the items returned from the ajax call.

    toiletApp.module.factory('Toilet', function () {               

    var Toilet = function (name, lat, lng, isPaying, street, houseNumber) {
        var lastCalculatedCoord;
        var lastCalculatedDistance;

        this.name = name;
        this.latitude = lat;
        this.longitude = lng;
        this.isPaying = isPaying;
        this.street = street;
        this.houseNumber = houseNumber;
        this.lastCalculatedDistance = function () {
            return lastCalculatedDistance;
        };
        this.calculateDistance = function (coordinates) {
            if (coordinates) {
                if (lastCalculatedCoord == coordinates) {
                    return lastCalculatedDistance;
                }

                var currentPosLatLon = new LatLon(coordinates.latitude, coordinates.longitude);
                var destinationPosLatLon = new LatLon(this.latitude, this.longitude);
                var dist = Math.ceil(currentPosLatLon.distanceTo(destinationPosLatLon) * 1000);

                lastCalculatedCoord = coordinates;
                lastCalculatedDistance = dist;

                return lastCalculatedDistance;
            }
            return null;
        };
        this.getMapUrl = function () {
            var coord = this.latitude + "," + this.longitude;

            return "...";
        };
    };

The Toilet class also has a method to calculate the distance from the
item to any given coordinate. I first wanted to make use of the [Google
Distance Matrix
API](https://developers.google.com/maps/documentation/distancematrix/)
to calculate the actual travel distance, but that didn't really work out
to well for more than 100 items; you can't batch your requests, and the
free version of the API has a threshold on the amount of queries. I
turned to calculating the great-circle distance instead, using [this
library](http://www.movable-type.co.uk/scripts/latlong.html).  
  
Since we want to make use of the client's coordinates, I also defined a
geo service, which makes use of the [HTML5 GeoLocation
API](http://www.jefclaes.be/2010/12/html5-geolocation-api-is-scary-good.html)
to query for the user's coordinates.

    toiletApp.module.factory('geoService', function() {

        return {

            getLocation: function (onSucess, onError, onNotAllowed) {
                if (navigator.geolocation) {

                    navigator.geolocation.getCurrentPosition(

                        function (position) {
                            onSucess(position);
                        },

                        function (err) {
                            onError(err);
                        }

                    );

                } else {
                    onNotAllowed(message);
                }
            }

        };

    });

After defining these pieces, I injected them into the ContentController.
The
[controller](http://docs.angularjs.org/guide/dev_guide.mvc.understanding_controller)
is responsible for augmenting angular's scope, which is the connection
to our view, our model. Properties and methods are made available to the
view by augmenting the $scope variable. There is quite some not that
interesting tinkering going on in the controller, so I left it out for
brevity.

    toiletApp.ContentController = function ($scope, geoService, toiletService) {
        $scope.toilets = [];
        ...
    }

After setting ng-app and ng-controller, we can make use of angular's
[directives](http://docs.angularjs.org/guide/directive) and
[filters](http://docs.angularjs.org/guide/dev_guide.templates.filters.using_filters)
to render our page. Directives are - as the documentation puts it - a
way to teach HTML new tricks. Think of it as HTML helpers. Filters are
used to format data.  
  
The view binds each toilet to a new collapsible div. The content of the
div shows some basic information, and a button which shows the toilet on
a map.

    <html ng-app="toiletModule">
        <head>
            ....
        </head>
        <body>
            <div data-role="page" id="home" ng-controller="toiletApp.ContentController"> 
                
                <div data-role="header">
                    <h1>Where to pee in Antwerp?</h1>
                    <a href="#" data-icon="refresh" ng-click="reload()">Reload</a>                
                </div> 
                
                <div data-role="content">
                    
                    <div class="content-primary">    
                        <p>{{ message }}</p>
                       
                        <div data-role="collapsible" 
                             ng-repeat="toilet in toilets | limitTo: itemsLimit()">
                            <h3>
                                {{ toilet.name }} 
                                ({{ toilet.lastCalculatedDistance() | distance }}) 
                                {{ toilet.isPaying | isPayingDollarSign }} 
                            </h3>                        
                            <p><strong>Name: </strong>{{ toilet.name }}</p>
                            <p><strong>Distance: </strong>{{ toilet.last..() | distance }}</p>
                            <p><strong>Paying: </strong>{{ toilet.isPaying | isPayingYesNo }}</p>
                            <p><strong>Street: </strong>{{ toilet.street }} </p>
                            <p><strong>Housenumber: </strong>{{ toilet.houseNumber }} </p>
                            <a href="{{ toilet.getMapUrl() }}" data-role="button">
                                Show location on a map
                            </a>
                        </div>                     
                                 
                        <div ng-show="hasMoreItemsToShow()">
                            <button ng-click="showMoreItems()">Show more toilets</button>    
                        </div>        
                    </div>        

                </div> 
                
                <div data-role="footer">
                    <h4>Made possible by Antwerp Open Data</h4>
                </div> 
            </div>
        </body>    
    </html>

You might notice how I used filters to format the isPaying and distance
property. These are also defined in the module.

    toiletApp.module.filter('isPayingDollarSign', function () {
        return function (value) {
            return value ? "$" : "";
        }
    });

    toiletApp.module.filter('isPayingYesNo', function () {
        return function (value) {
            return value ? "Yes" : "No";
        }
    });

    toiletApp.module.filter('distance', function () {
        return function (value) {
            return value ? value + "m" : "";
        }
    });

  
**Summary**  
  
I can only applaud the Open Data initiative; my hope is that the
datasets get more interesting though. Which also makes me wonder if the
government is even measuring the more interesting stuff?  
  
All in all, these two applications aren't very innovative. Yet, they did
give me the opportunity to experiment with some stuff I can't play with
on the day job (yet). I'm always amazed how quickly you can slap
together a small application using the available building blocks out
there. I'm most content with picking up angular.js; I will be
advertising this framework in a professional context from now on.
