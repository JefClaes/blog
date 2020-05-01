+++
title = "Recursively spawning Web Workers"
slug = "2011-07-21-recursively-spawning-web-workers"
published = 2011-07-21T15:00:00.004000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "javascript", "Browsers", "HTML5", "LOL",]
+++
I like to think of [HTML5 Web Workers](http://dev.w3.org/html5/workers/)
simply as 'threading for the Web'.  
  
[Wikipedia](http://en.wikipedia.org/wiki/Web_Workers) describes it a bit
more in detail.  

> Web Workers define an API for running scripts, basically JavaScript,
> in the background independently of any user interface scripts. This
> allows for long-running scripts that are not interrupted by scripts
> that respond to clicks or other user interactions, and allows long
> tasks to be executed without yielding to keep the page responsive.

You can start a Web Worker like this.  

  

    if (typeof(Worker) === "undefined") {

        alert("Web Workers not supported in your browser.");

    } else {

        var worker = new Worker("worker.js");

    }

  
The Web Worker API allows workers to create subworkers. The fun quirk
here is that you can start a worker that recursively spawns another
worker with the same JavaScript file.  
  
So in worker.js, you can do this.  
  

    var worker = new Worker("worker.js");

  
And as you can guess, this has some interesting effects.  
  
[![](../images/thumbnails/2011-07-21-recursively-spawning-web-workers-WebWorkersSpawning.PNG)](../images/2011-07-21-recursively-spawning-web-workers-WebWorkersSpawning.PNG)  
Try it yourself
[here](http://dl.dropbox.com/u/19698383/Blog/Workers/default.html).
