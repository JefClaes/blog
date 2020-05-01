+++
title = "Show More pagination with angular.js"
slug = "2012-12-12-show-more-pagination-with-angular-js"
published = 2012-12-12T19:57:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC", "javascript", "Browser",]
+++
I built my first application with [angular.js](http://angularjs.org/)
over these last few weeks (not during business hours), and although I
still have lots and lots to discover and learn, I think I somewhat grasp
the basics.  
  
In the application I built, I had to implement paging because rendering
all the items at once was too slow on mobile devices (on my Windows
Phone 7 anyways). The paging variant I decided on was the 'Show More'
technique.  
  
Let me walk you - as an introduction to Angular - through a simple
application that uses paging for a list of 24 items.  
  
We start by defining a [module](http://docs.angularjs.org/guide/module).
In an Angular module, you should instantiate, wire and bootstrap parts
of your application.  

    var module = angular.module('module', []);

We can already bind the module to our empty view.

    <div ng-app="module">
    </div>

In our module we want to define an itemService which will return an
array of 24 items. By using a factory method we make our service an
[injectable dependency](http://docs.angularjs.org/guide/di) for other
parts of our application.

    module.factory('itemService', function() {
        return {
            getAll : function() {
                var items = [];
                for (var i = 1; i < 25; i++) {
                    items.push('Item ' + i);                       
                }
                return items;
            }
        };              
    });

Now that we have a service that can give us items, we want to work
towards actually rendering these items. To do that, we'll have to define
a
[controller](http://docs.angularjs.org/guide/dev_guide.mvc.understanding_controller).
An Angular controller lets you augment an instance of Angular's scope,
which in its turn serves as your connection to the view. 

    ListController = function($scope, itemService) {
        $scope.items = itemService.getAll();    
    };

Notice how we use dependency injection to inject an instance of the
itemService.  
  
All our items are available on the scope now, but we still have an empty
view. Let's fix that.  

    <div ng-app="module" ng-controller="ListController">
        <ul>
           <li ng-repeat="item in items">
              {{ item }}        
           </li>               
        </ul>
        <button>Show more</button>    
    </div>

Items are being rendered making use of Angular's built-in ng-repeat
directive. [Directives](http://docs.angularjs.org/guide/directive) are -
as the documentation puts it nicely - a way to teach HTML new tricks.
MVC folks may think of it as HTML helpers.  
  
What's left to do in this example, is what we initially set out to do;
implement paging. For that, we'll first add some extra variables to the
controller, and some new methods on to the scope. These should be
self-descriptive.

    ListController = function($scope, itemService) {
        var pagesShown = 1;
        var pageSize = 5;
        $scope.items = itemService.getAll();
        $scope.itemsLimit = function() {
            return pageSize * pagesShown;
        };
        $scope.hasMoreItemsToShow = function() {
            return pagesShown < ($scope.items.length / pageSize);
        };
        $scope.showMoreItems = function() {
            pagesShown = pagesShown + 1;         
        };
    };​

We can now make use of those new methods on the scope in our view. 

    <div ng-app="module" ng-controller="ListController">
        <ul>
           <li ng-repeat="item in items | limitTo: itemsLimit()">
              {{ item }}        
           </li>               
        </ul>
        <button ng-show="hasMoreItemsToShow()" ng-click="showMoreItems()">Show more</button>    
    </div>

We made use of directives to add behaviour to the 'Show more' button and
used the limitTo filter to limit the number of items rendered. Filters
are used to format display data.  
  
**Here is the full
[jsFiddle](http://jsfiddle.net/JefClaes/HPu9n/9/).**  
  
I'm pretty sure you can abstract paging into a reusable component, but I
thought this scenario shows a good bunch of basic Angular concepts.  
  
*So what are your thoughts on Angular? Pretty slick, right? Or are you
already using Angular?*
