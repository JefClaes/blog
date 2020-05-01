+++
title = "Rebinding a knockout view model"
slug = "2014-04-06-rebinding-a-knockout-view-model"
published = 2014-04-06T18:43:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC", "javascript",]
+++
As you might have noticed reading my last two posts, I have been doing a
bit of front-end work using [knockout.js](http://knockoutjs.com/). Here
is something that had me scratching my head for a little while..  
  
In one of our pages we're subscribing to a specific event. As soon as
that event arrives, we need to reinitialize the model that is bound to
our container element. Going through snippets earlier, I remembered
seeing the cleanNode function being used a few times - which I thought
would remove all knockout data and event handlers from an element. I
used this function to clean the element the view model was bound to, for
then to reapply the bindings to that same element.  
  
This seemed to work fine, until I used a foreach binding. If you look at
the snippet below, what is the result you would expect?

    <div id="books">
        <ul data-bind="foreach: booksImReading">
            <li data-bind="text: name"></li>
        </ul>
    </div>

    var bookModel = {
        booksImReading: [
            { name: "Effective Akka" }, 
            { name: "Node.js the Right Way" }]
    };
                             
    ko.applyBindings(bookModel, el);

    var bookModel2 = {
        booksImReading: [
            { name: "SQL Performance Explained" },
            { name: "Code Connected" }]
    };

    ko.cleanNode(books);
    ko.applyBindings(bookModel2, books);

Two list-items? One for "SQL Performance Explained" and one for "Code
Connected"? That's what I would expect too. The actual result shows two
list-items for "SQL Performance Explained" and two for "Code Connected"
- four in total. The cleanNode function is apparently not cleaning the
foreach binding completely.  
  
Looking for documentation on the cleanNode function, I couldn't find
any. What I did find was a year old Stackoverflow answer advising
against using this function - since it's intended for internal use
only.  
  
I ended up making the book model itself an observable. The element is
now being bound to a parent model that contains my original book model
as an observable. When the event arrives now, I create a new book model
and set it to that observable property. This results in my list being
rerendered with just two items - like expected.

    <div id="books">
        <ul data-bind="foreach: bookModel().booksImReading">
            <li data-bind="text: name"></li>
        </ul>
    </div>

    var page = {
        bookModel : ko.observable({
            booksImReading: [
                { name: "Effective Akka" }, 
                { name: "Node.js the Right Way" }]
        })
    };
                              
    ko.applyBindings(page, el);

    page.bookModel({
        booksImReading: [
            { name: "SQL Performance Explained" },
            { name: "Code Connected" }]
    });

Don't use the cleanNode function to rebind a model - instead make the
model an observable too.
