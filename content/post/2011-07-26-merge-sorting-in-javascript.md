+++
title = "Merge sorting in JavaScript"
slug = "2011-07-26-merge-sorting-in-javascript"
published = 2011-07-26T19:00:00.005000+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2011/07/merge-sorting-in-javascript_1458.html"
+++
The latest addition to my [data structures and algorithms in
JavaScript](https://github.com/JefClaes Data-structures-and-algorithms-in-JavaScript)
is the merge sort algorithm.  
  
There are four main steps in the merge sort algorithm (from
[Wikipedia](http://en.wikipedia.org/wiki/Merge_sort)):
- If the list is of length 0 or 1, then it is already sorted.

Otherwise:
- Divide the unsorted list into two sublists of about half the size.
- Sort each sublist recursively by re-applying the merge sort.
- Merge the two sublists back into one sorted list.

I found it a lot easier to understand the algorithm by just looking at
this diagram (also from [Wikipedia](http://en.wikipedia.org/wiki/Merge_sort)).  
  
[![](/post/images/thumbnails/2011-07-26-merge-sorting-in-javascript-MergeSort.png)](/post/images/2011-07-26-merge-sorting-in-javascript-MergeSort.png)  

I added a public `mergeSort` function to the `sortArray` object, which I
showed in the [first post](https://jefclaes.be/2011/07/simple-sorting-in-javascript.html) in these series.  
  
```js
this.mergeSort = function() {                                       
    elements = internalMergeSort(elements, this.onSort);                
    return elements;
};     
```
  
This function calls the `internalMergeSort` function passing in the
internal elements array and the onSort callback.  
  
```js
var internalMergeSort = function(elements, onSort){            
    if (elements.length < 2){                               
        return elements;  
    }                           

    // Calculate the middle of the elements
    var middle = Math.floor(elements.length / 2);           
    // Divide 
    var leftRange = elements.slice(0, middle);
    var rightRange = elements.slice(middle, elements.length);           
    // Conquer                                                           
    var mergingResult = merge(internalMergeSort(leftRange, onSort), 
                              internalMergeSort(rightRange, onSort));                                   
    onSort(mergingResult);           

    return mergingResult;
};
```
  
The function recursively divides the elements in two parts, sorting them
and finally merging them back together.  
  
The `merge` function is implemented like this.  

```js

function merge(left, right){                      
    var res = [];           

    while (left.length > 0 && right.length > 0) {                
        if (left[0] <= right[0]) {
            res.push(left.shift());
        } else {
            res.push(right.shift());
        }                                              
    }           
    
    while (left.length > 0) {                
        res.push(left.shift());
    }            

    while (right.length > 0) {            
        res.push(right.shift());
    }

    return res;
};  
```

I peeked at [this implementation](http://css.dzone.com/news/friday-algorithms-javascript?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+zones%2Fcss+(CSS+Zone)), 
which is very similar to mine and which helped me write the first while
loop more elegantly.  
  
Testing sorting algorithms is pretty easy. So far, I have only defined
one [QUnit](http://docs.jquery.com/Qunit) test for this algorithm.  

```js
test("MergeSort sorts.", function() {
    var sortArray = new algorithms.sortArray();

    sortArray.push(15);
    ...
    sortArray.push(130); 

    var actual = sortArray.mergeSort();                               
    var expected = [1, 10, 12, 15, 17, 22, 25, 50, 60, 90, 130];

    deepEqual(actual, expected);
});  
```

A small remark here is that you should [use deepEqual](https://github.com/jquery/qunit/issues/27) instead of `equal` for array assertions. We want to compare the contents of the array, not
their references.
