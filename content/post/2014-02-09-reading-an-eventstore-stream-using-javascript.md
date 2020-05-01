+++
title = "Reading an EventStore stream using JavaScript"
slug = "2014-02-09-reading-an-eventstore-stream-using-javascript"
published = 2014-02-09T18:07:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "javascript", "DDD",]
+++
Over Christmas break, I set out three days to play with the
[EventStore](http://geteventstore.com/). One of the things I wanted to
do was visualize the timeline of a stream in the browser. Since the
EventStore exposes its event streams over atom in JSON, I could directly
consume them from JavaScript.  
  
An event stream can contain quite a few events. Since caching parts of
that stream benefits all components in the system, the atom feed is
split in multiple pages - where all full pages are cacheable. Thus if
you want to read the entire event stream, you should work your way
through all pages. What confused me at first, but what actually is quite
logical, is that the last entry on the last page contains the first
event. If you want to read the entire stream, you need to start at the
last page, and work your way forward following the link to the previous
page until there are no pages left to read.  
  

[![](/post/images/thumbnails/2014-02-09-reading-an-eventstore-stream-using-javascript-eventstoreatom.png)](/post/images/2014-02-09-reading-an-eventstore-stream-using-javascript-eventstoreatom.png)

  
I came up with something like this.  

    StreamFeedReader : function(feedUri) {   

        if (!feedUri) {
            throw new Error('feedUri missing.');
        }        
        
        var readLastFromHead = function (streamName) {                                        
            var dfd = $.Deferred();

            $.ajax({
                url : feedUri + streamName + '?embed=body'
            }).done(function (data) {                
                var lastLinks = data.links.filter(function(link) { 
                    return link.relation === 'last'; 
                });                       

                if (lastLinks.length > 0) {               
                    dfd.resolve(lastLinks[0].uri);           
                } else {
                    dfd.resolve(feedUri + streamName);
                }
            }).fail(function() {                           
                dfd.reject();
            });

            return dfd.promise();
        };              

        var traverseToFirst = function (uri, entries, dfd) {                                                       
            $.ajax({
                url: uri + '?embed=body'
            }).done( function (data) {       
                var reversedEntries = data.entries.reverse();

                for (var i = 0; i < reversedEntries.length; i++) {
                    entries.push(reversedEntries[i]);
                }            

                var previousLinks = data.links.filter(function(link) { 
                    return link.relation === 'previous'; 
                });            

                if (previousLinks.length === 1) {
                    traverseToFirst(previousLinks[0].uri, entries, dfd);
                } else {                
                    dfd.resolve(entries);
                }           
            }).fail(function() {
                dfd.reject();
            });                    
        };  

        this.read = function (streamName) {                   
            if (!streamName) {
                throw new Error('streamName missing.');
            }  

            var dfd = $.Deferred();                           
            
            readLastFromHead(streamName).done(function(lastUri) {
                var entries = [];                        
                traverseToFirst(lastUri, entries, dfd);                        
            }).fail(function() { 
                dfd.reject(); 
            });    

            return dfd.promise();              
        };

    }

First read the link to the last page. From there, read the entries on
that page, look at the links on that page and start making your way
forward, traversing the pages to the first one. All events on the page
should also be reversed before they get pushed to the result.  

  

Using this snippet, you can read a stream and have all events returned
in the sequence they were appended.

    new es.StreamFeedReader('http://127.0.0.1:2113/streams/')
        .read('account-35')
            .fail(function() {
                test.ok(false, 'reading the stream failed.');
                test.done();
            })
            .done(function(res) {
                var streamContainsAllEvents = function() {
                    test.equal(651, res.length, 'expecting 651 events in stream.');
                };
                var eventsInStreamAreOrdered = function() {
                    var ordered = true;
                    for (var i = 1; i < res.length; i++) {
                        if (res[i - 1].eventNumber > res[i].eventNumber) {                            
                            ordered = false;
                        }
                    }
                    test.ok(ordered, 'event numbers out of order.');
                };

                streamContainsAllEvents();
                eventsInStreamAreOrdered();                                

                test.done();
            });

This code is also available on
[GitHub](https://github.com/JefClaes/eventstore-streamfeedreader).
