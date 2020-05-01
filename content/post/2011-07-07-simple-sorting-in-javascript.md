+++
title = "Simple sorting in JavaScript"
slug = "2011-07-07-simple-sorting-in-javascript"
published = 2011-07-07T21:30:00.015000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "javascript",]
+++
About three years ago I graduated and got my degree in Applied Computer
Science. Although it says Computer Science, we hardly ever focused on
data structures and algorithms. Obviously, I now see that as a
shortcoming. So I plan to make up for that by reading up on some of the
basics. While at it, I might be blogging on some of the topics.  
  
I am going to start by implementing some of the simple sorting
algorithms in JavaScript.  
  
<span style="font-style:italic;">Find the final result
[here](http://dl.dropbox.com/u/19698383/Blog/JavaScriptAlgorithmsDataStructs/Implementations/SimpleSorting.html).</span>  
  
**Bubble sort**  
  
The first sorting algorithm I'm going to implement is probably also the
easiest, and slowest in most scenario's: [Bubble
sort](http://en.wikipedia.org/wiki/Bubblesort).  

> Bubble sort is a simple sorting algorithm that works by repeatedly
> stepping through the list to be sorted, comparing each pair of
> adjacent items and swapping them if they are in the wrong order. The
> pass through the list is repeated until no swaps are needed, which
> indicates that the list is sorted.

Let's start by defining a namespace.  
  

    var algorithms = { };

  
We could extend the native array object, but to keep things simple,
let's create our own sortArray object.  
  

    var algorithms = {         

        sortArray : function(){

                    

        } 

    };

  
The sortArray object contains a private array of elements. To add
elements to that array, we will expose a push function on our sortArray
object.  
  

    var algorithms = {         

        sortArray : function(){

            var elements = [];                                                                           

                         

            this.push = function(val){

                elements.push(val);                    

            };                                       

        } 

    };

  
So far we can do something like this.  
  

    var sortArr = new algorithms.sortArray();               

                 

    sortArr.push(80);

    sortArr.push(20);

    sortArr.push(...);

  
Now we have to add a public sort function. Before we do that we need to
define a private swap function, which can swap elements.  
  

    var swap = function(one, two) {

        var tmp = elements[one];

        elements[one] = elements[two];

        elements[two] = tmp;                    

    };

  
The bubbleSort function will take a callback argument which will be
called every sort iteration.  
  

    this.bubbleSort = function(callback) {   

        callback(elements);

        //Loop over all the elements

        for (var out = elements.length - 1; out > 0; out--){                            

            for (var inn = 0; inn < out; inn++) {

                //Are they out of order?

                if (elements[inn] > elements[inn+1]){

                    swap(inn, inn+1);                                

                } 

            }

            callback(elements);

        }                    

    };

  
That should be it. Now let's try to push some elements in the array,
define a callback and call the bubbleSort function. In the callback
function I'm using the [Google Charts
API](http://code.google.com/intl/nl-BE/apis/chart/) to visualize the
sorting process.  

  

    $(document).ready(function() {             

        ...                                 

                    

        var results = $("#results");

        

        var drawElements = function(elements) {                            

            var chd = "";                    

            

            for (var e in elements) {

                chd += elements[e].toString() + ",";

            }

            

            //Remove that last ","

            chd = chd.substring(0, chd.length - 1);                        

            

            //Build the Google Charts url

            var chartUrlBase = "http://chart.apis.google.com/chart?chxt=y&chbh=a&chs=300x225&cht=bvg&chco=A2C180,3D7930&chtt=Sorting";

            var chartUrlComplete = chartUrlBase + "&chd=t:" + chd;                                    

            

            $("#results").append("<img src='" + chartUrlComplete + "'/>").append("<br/>");                                                                                                                                         

        }                              

                             

        sortArr.bubbleSort(drawElements);                               

    });

  
**Selection sort**  
  
The second algorithm is [Selection
sort](http://en.wikipedia.org/wiki/Selection_sort). I found this one the
easiest to understand so far: find the mimimum value, swap it with the
value in the first position, advance one position and repeat.  

> Selection sort is a sorting algorithm, specifically an in-place
> comparison sort. It has O(n2) time complexity, making it inefficient
> on large lists, and generally performs worse than the similar
> insertion sort. Selection sort is noted for its simplicity, and also
> has performance advantages over more complicated algorithms in certain
> situations, particularly where auxiliary memory is limited.

Let's start by giving the BubbleSort callback function another place. We
will make this a public function on our sortArray. I will name it onSort
and set it to an empty function by default.  
  

    this.onSort = function() {};      

  
Once that is done we can define our public selectionSort function. This
function calls the onSort function every sort iteration.  

  

    this.selectionSort = function(){

        this.onSort(elements);

        for (var out = 0; out < elements.length - 1; out++) {

            var min = out;

            for (var inn = out; inn < elements.length; inn++) {

                //If minium greater => new minimum

                if (elements[inn] < elements[min]){

                    min = inn;

                }                            

            }

            swap(out, min);

            this.onSort(elements);

        }

    };

  
**Insertion sort**  
  
The last simple sorting algorithm I'm going to implement in this post is
[Insertion sort](http://en.wikipedia.org/wiki/Insertion_sort).  

> Insertion sort is a simple sorting algorithm: a comparison sort in
> which the sorted array (or list) is built one entry at a time.  
>   
> Every repetition of insertion sort removes an element from the input
> data, inserting it into the correct position in the already-sorted
> list, until no input elements remain. The choice of which element to
> remove from the input is arbitrary, and can be made using almost any
> choice algorithm.

The insertionSort is just another public function on our sortArray
object.  
  

    this.insertionSort = function(){

        this.onSort(elements);

        for (var out = 1; out < elements.length; out++){                        

            var temp = elements[out];

            var inn = out;

            

            //Until one is smaller

            while (inn > 0 && elements[inn-1] >= temp){

                elements[inn] = elements[inn-1];

  

                inn--;

            }

            elements[inn] = temp;

            this.onSort(elements);

        }

    }

  
You can **find the final result
[here](http://dl.dropbox.com/u/19698383/Blog/JavaScriptAlgorithmsDataStructs/Implementations/SimpleSorting.html)**.
If you have any remarks on these implementations, please let me know!  
  
[![](/post/images/thumbnails/2011-07-07-simple-sorting-in-javascript-SortResult.PNG)](/post/images/2011-07-07-simple-sorting-in-javascript-SortResult.PNG)
