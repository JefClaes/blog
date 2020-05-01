+++
title = "Consumed: Parsing command line arguments (F#)"
slug = "2015-04-19-consumed-parsing-command-line-arguments-f"
published = 2015-04-19T16:54:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "F#",]
+++
Last year, I set out to write my first node.js application; a small web
application for keeping lists of [everything I
consume](http://www.jefclaes.be/2015/01/consumed-in-2014.html). I had
something working pretty quickly, deployed it to Heroku and still find
myself using it today. Since there's very little use for having it
running on a server, and because I wanted something to toy with getting
better at F\#, I decided to port it to an F\# console application.  
  
With the UI gone, I need to resort to passing in arguments from the
command line to have my program transform those into valid commands and
queries that can be executed.  
  
The set of commands and queries is limited; consume an item, remove an
item and query a list of everything consumed.

  

Ideally I go from a sequence of strings to a typed command or query.
However, when the list of arguments can't be parsed, I expect a result
telling me what failed just the same.

  

Since we need the name to identify the command or query, I expect the
input to have at least two arguments.

  

Arguments come in pairs; a key and a value. My first thought was to
build a map here, but that made key validation, key transformations and
pattern matching harder.  I can actually get away with transforming the
input to a sequence of tuples.

  

Hoping to avoid some mistakes in the input, basic validation makes sure
the keys actually look like keys, instead of a value. Keys start with a
single or double dash.

  

Once that validation is out of the way, I strip away those dashes. That
should make the two last steps easier.

  

The name is required, so I wrote a small function that makes sure a
specific key exists.

  

Now that I have a list of arguments,  I can map them into a typed
command or query using pattern matching.

  

Having written all these small functions, I can simply compose them
using [Scott Wlaschin](https://twitter.com/scottwlaschin)'s [Railway
oriented
programmming](http://fsharpforfunandprofit.com/posts/recipe-part2/).  
  

This is far from a generic command line parser, but it's simple and
covers my needs.  
  
Next up, executing those commands and queries, and printing feedback.
