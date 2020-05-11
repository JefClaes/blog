+++
title = "Overoptimizing my JavaScript stack implementation for fun"
slug = "2011-07-18-overoptimizing-my-javascript-stack-implementation-for-fun"
published = 2011-07-18T21:00:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2011/07/overoptimizing-my-javascript-stack.html"
+++
[Davy Brion](http://davybrion.com/blog/) made a comment on [my
JavaScript stack/queue implementation](https://jefclaes.be/2011/07/stacks-and-queues-in-javascript.html) on Twitter last night: Any reason why you don't immediately set elements to \[\] at declaration in your stack/queue example?  

```js
var elements;

this.push = function(element) {
    if (typeof(elements) === 'undefined') {
        elements = [];   
    }                            

    elements.push(element);
}
```

Yes, I made an overoptimization, and a bad one. In this implementation,
you save a few bytes in memory if you initialize the stack, but don't
push elements. This might have made some sense 15 years ago, but today a
few bytes are very negligible compared to the cost of evaluating the
elements reference on every push call.  
  
Anyway, thinking about this driving home, I thought of another
optimization, which meets both arguments and is far more *fun*.  

```js
this.push = function(element) {                        
    elements = [];   
    elements.push(element);                            
    this.push = function(element) {
        //Rewriting self. Overoptimization ftw!
        elements.push(element);                                   
    }                                                 
}
```
  
The first time the push function is executed, the elements array is
initialized. In the same function, the function rewrites itself to no
longer initialize the elements array. So the second time the push
function is called, it will no longer initalize the array, but only push
a new item to the existing elements array.  
  
**Dynamilicious!**
