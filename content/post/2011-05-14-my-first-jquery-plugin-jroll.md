+++
title = "My first jQuery plugin: jRoll"
slug = "2011-05-14-my-first-jquery-plugin-jroll"
published = 2011-05-14T17:45:00.002000+02:00
author = "Jef Claes"
tags = [ "javascript", "jQuery",]
+++
With transitioning to ASP.NET MVC, I see our JavaScript codebase
increasing exponentially. And this is a big win, unless we fail to keep
that codebase maintainable. We mainly rely on jQuery to do our DOM
manipulations, so it's only logical for us to abstract those
manipulations into reusable jQuery plugins.  
  
So today, I wrote my first jQuery plugin and named it jRoll.  
  
**jRoll**  
  
jRoll is a plugin that finds all the (external) links in a jQuery
object, and replaces the value of the href attribute with a value you
specified. If you don't specify that value, [the default
value](http://www.youtube.com/watch?v=4R-7ZO4I1pI) is used, hence the
Roll.  
  
It can be used like this.  
  

    $('body').jRoll(); 

  
But it can and should be used like this.  
  

    $('body').jRoll({ 'url' : 'http://www.google.com' }); 

  
I'm also not breaking the chain.  
  

    $('body').jRoll().click(function() { alert('Never gonna give you up') });

  
Anyhow, here is the source of my first not-so-serious jQuery plugin.  
  

    // Pass jQuery to a closure that maps to $ so it can't be overwritten

    // by another library in the scope of its execution

    (function($) {

        // Add a new function to the jQuery.fn object (your plugin name)

        $.fn.jRoll = function(options) {    

            // Default settings

            var settings = {

                'url' : 'http://www.youtube.com/watch?v=4R-7ZO4I1pI'

            };

            

            // Merge defaults with options argument

            if (options) { 

                $.extend(settings, options);

            }

        

            // Modify elements and return them to maintain chainability

            // this refers to the jQuery object the plugin was invoked on

            return this.each(function () {                    

                $(this).find('a[href^="http://"]').attr('href', settings.url);

            });

        }

    })(jQuery);

  
To build your first plugin, I recommend you use the [excellent jQuery
documentation](http://docs.jquery.com/Plugins/Authoring).  
  
Download the full jRoll source
[here](http://dl.dropbox.com/u/19698383/Blog/jRoll.html).  
  
[![](/post/images/thumbnails/2011-05-14-my-first-jquery-plugin-jroll-rick-roll.jpg)](/post/images/2011-05-14-my-first-jquery-plugin-jroll-rick-roll.jpg)
