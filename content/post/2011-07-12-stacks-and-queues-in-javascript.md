+++
title = "Stacks and queues in JavaScript"
slug = "2011-07-12-stacks-and-queues-in-javascript"
published = 2011-07-12T21:00:00.002000+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2011/07/stacks-and-queues-in-javascript.html"
+++
The second assignment in my 'implementing data structures and algorithms
in JavaScript' quest consists of two popular data structures: the [stack](http://en.wikipedia.org/wiki/Stack_(data_structure)) and the [queue](http://en.wikipedia.org/wiki/Queue_(data_structure)).  
  
### The stack

> A stack is a last in, first out (LIFO) abstract data type and data
> structure. A stack can have any abstract data type as an element, but
> is characterized by only three fundamental operations: push, pop and
> stack top.

Implementing this turned out to be pretty easy. A [native JavaScript
array](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array) already exposes methods to
[push](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/push) and [pop](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/pop) elements. In the `dataStructures` namespace, I defined a stack object. The
`stack` object contains a private array which is initialized as soon as
the first element is pushed into the stack. The public `push` and `pop`
functions expose the corresponding functions of the private array. The
`stackTop` function returns the last element added to the stack, but
doesn't remove it from the internal array.  
  
```js
var dataStructures = {
    stack : function() {                  

        var elements;

        this.push = function(element) {
            if (typeof(elements) === 'undefined') {
                elements = [];   
            }                            
            elements.push(element);
        }

        this.pop = function() {
            return elements.pop();
        }

        this.stackTop = function(element) {
            return elements[elements.length - 1];
        }
    }
}
```

Although a native array contains most stack operations, the stack object
we made is still pretty useful. We end up with a clean encapsulated
stack which only exposes the core stack operations.  
  
```js
var someStack = new dataStructures.stack();

someStack.push(1);
someStack.push(2);
someStack.push(3);

var stackTopResult = someStack.stackTop();                         
stackTopResults.html(stackTopResult);

var popResult = "";

popResult += someStack.pop();
popResult += someStack.pop();
popResult += someStack.pop();
```
  
### The queue 

> A queue is a particular kind of collection in which the entities in
> the collection are kept in order and the principal (or only)
> operations on the collection are the addition of entities to the rear
> terminal position and removal of entities from the front terminal
> position. This makes the queue a First-In-First-Out (FIFO) data
> structure. In a FIFO data structure, the first element added to the
> queue will be the first one to be removed.

As with the stack, the native array object already contains a few
functions which help us implement a queue. The terminology doesn't
completely match though. `Enqueue` maps with `pop` and `dequeue` maps with [shift](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/shift).  
  
I added the `queue` object to the `dataStructures` namespace. The queue also holds a private array of elements. The `enqueue` function pushes a new element on the queue, and the dequeue function removes the first element from the queue. The `peek` function returns the first element in the array, but does not remove it.  

```js
queue : function() {
    var elements;

    this.enqueue = function(element) {
        if (typeof(elements) === 'undefined') {
            elements = [];   
        }
        elements.push(element);                       
    }

    this.dequeue = function() {
        return elements.shift();                                   
    }

    this.peek = function(){
        return elements[0];                  
    }
}
```

The queue can be used like this.  

```js
someQueue.enqueue(1);
someQueue.enqueue(2);
someQueue.enqueue(3);               

var queuePeekResult = someQueue.peek();

queuePeekResults.html(queuePeekResult); 

var dequeueResult = "";                   

dequeueResult += someQueue.dequeue();
dequeueResult += someQueue.dequeue();
dequeueResult += someQueue.dequeue(); 
```
  
Find **the final result
[here](http://dl.dropbox.com/u/19698383/Blog/JavaScriptAlgorithmsDataStructs/Implementations/StackQueues.html)**.
Also check out the previous post on [simple sorting in
JavaScript](https://www.jefcles.be/2011/07/simple-sorting-in-javascript.html).
