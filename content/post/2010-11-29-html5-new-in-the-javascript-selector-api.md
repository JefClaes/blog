+++
title = "HTML5: New in the javascript Selector API"
slug = "2010-11-29-html5-new-in-the-javascript-selector-api"
published = 2010-11-29T19:30:00.004000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "javascript", "Browsers",]
+++
Because I finally got the MCTS 70-536 certification out of the way, I
can start experimenting with some fun stuff again. One of the things on
the top of my list is HTML5. I started reading the book [Pro HTML5
Programming](http://www.amazon.com/gp/product/1430227907?ie=UTF8&tag=diofanedebyje-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=1430227907),
so expect more posts on HTML5 in the near future.  
  
In this post I will show you two new methods in the javascript Selector
API which are extremely useful to find elements.  
  
**Specificiations**  
  
Methods we can now use to find elements are
[getElementById()](https://developer.mozilla.org/en/document.getElementById),
[getElementsByName()](https://developer.mozilla.org/en/DOM/document.getElementsByName)
and
[getElementsByTagName](https://developer.mozilla.org/en/DOM/document.getElementsByTagName)().
In HTML5 there are two new methods in the Selector API: querySelector()
and querySelectorAll(). These new methods find elements by matching
against a group of
[selectors](http://www.w3.org/TR/css3-selectors/#link).  
  
Their description as in the [W3C
specifications](http://www.w3.org/TR/selectors-api/) is:  

> The querySelector() method on the NodeSelector interface must, when
> invoked, return the first matching Element node within the node’s
> subtrees. If there is no such node, the method must return null.

> The querySelectorAll() method on the NodeSelector interface must, when
> invoked, return a NodeList containing all of the matching Element
> nodes within the node’s subtrees, in document order. If there are no
> such nodes, the method must return an empty NodeList.

  
**Throwing out some feelers**  
  
To play with these new methods I made a simple page which displays an
unordered list of methods in the Selector API. Existing methods have the
class *exists* and new methods have the class *new*.  
  

    <!DOCTYPE html>

    <html>

        <head>

            <title>HTML5: Selector API</title>        

            <style type="text/css">

                html {

                    font-family: Verdana;

                    font-size: 1.2em;

                }

                

                #header {

                    width: 100%;

                }        

                            

                .exists {

                    font-style: italic;

                }

                

                .new {

                    color: green;

                    font-weight: bold;

                }

            </style>

        </head>

        <body>

            <div id="header">

                <h1>HTML5: Selector API</h1>

            </div>

            <div id="content">

                <ul id="methodslist">

                    <li class="exists">getElementById</li>

                    <li class="exists">getElementsByName</li>

                    <li class="exists">getElementsByTagName</li>

                    <li class="new">[NEW] querySelector</li>

                    <li class="new">[NEW] querySelectorAll</li>                

                </ul>            

            </div>

        </body>

    </html>

  
To select the first new method we can use the querySelector() method
with the *li.new* Selector. The first matching element is returned.  
  

    function selectFirstNewMethod(){

        var firstNewMethod = document.querySelector('li.new');

        firstNewMethod.style.color = 'Red';

    }

  
To select all new methods we can use the querySelectorAll() method with
the *li.new* Selector. All matching elements are returned.  
  

    function selectAllNewMethods(){

        var allNewMethods = document.querySelectorAll('li.new');

        for (var i = 0; i < allNewMethods.length; i++){

            allNewMethods[i].style.color = 'Blue';

        }

    }

  
To select all methods (existing and new) we can use the
querySelectorAll() method with the *li.exists, li.new* Selector.  
  

    function selectExistingAndNewMethods(){

        var existingAndNewMethods = document.querySelectorAll('li.exists, li.new');

        for (var i = 0; i < existingAndNewMethods.length; i++){

            existingAndNewMethods[i].style.color = 'Yellow';

        }

    }

  
  
These examples just demonstrate the tip of the iceberg. Check out the
[Selectors specifications](http://www.w3.org/TR/css3-selectors/#link) to
see how they can be used to greatly improve the way of finding elements
in the DOM.  
  
**Demo and source**  
  
You can find the demo and source
[here](http://pastehtml.com/view/1c4rixv.html).  
  
**The HTML5 Selector API and jQuery?**  
  
I am far from a [jQuery](http://jquery.com/) or javascript expert, so I
wonder: how will these methods and selectors influence jQuery? Will they
be encapsulated into jQuery, because I can imagine that these natively
implemented methods will be a few times faster than [jQuery
Selectors](http://api.jquery.com/category/selectors/)?  
  
**Edit:** querySelectorAll is being used by jQuery since version 1.4.3.
([Source](http://stackoverflow.com/questions/4038878/jquery-will-not-exist-in-future)).
