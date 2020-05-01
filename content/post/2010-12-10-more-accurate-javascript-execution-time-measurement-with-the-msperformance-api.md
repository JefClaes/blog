+++
title = "More accurate javascript execution time measurement with the msPerformance API"
slug = "2010-12-10-more-accurate-javascript-execution-time-measurement-with-the-msperformance-api"
published = 2010-12-10T20:00:00.011000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "javascript", "Browsers",]
+++
A cool feature of [Internet Explorer
9](http://windows.microsoft.com/ie9) is the [msPerformance
API](http://msdn.microsoft.com/en-us/library/ff975118(VS.85).aspx). This
API helps you to accurately measure the performance of a webpage. A lot
of developers have built their own performance measurement constructs
over the years, based on the Date function, but the results of these
constructs can be way off!  
  
[John Resig](http://en.wikipedia.org/wiki/John_Resig) (jQuery inventor)
has [an in detail
blogpost](http://ejohn.org/blog/accuracy-of-javascript-time/) where he
discovers where custom javascript execution time measurement goes
wrong.  

> In Summary: Testing JavaScript performance on Windows XP and Vista is
> a crapshoot, at best. With the system times constantly being rounded
> down to the last queried time (each about 15ms apart) the quality of
> performance results is seriously compromised. Dramatically improved
> performance test suites are going to be needed in order to filter out
> these impurities, going forward.

  
Browsers know exactly how long it takes to load webpages and execute
scripts. IE9 now makes it possible to consume this information through
the msPerformance API.  
  
If you are interested in performance marks of the document loading, you
can read properties of the
[msPerfomanceTiming](http://msdn.microsoft.com/en-us/library/ff975075(v=VS.85).aspx)
object. If you are, like me, interested in measuring execution time of a
specifc function, you can use some functions of the msPerformance
object. Have a look at the following codesnippet.  
  

    function runTest(){                

        var msPerformance = window.msPerformance;

        

        if (msPerformance){        

            msPerformance.mark("writeLoopBegin");

            

            for (var  i = 0; i < 50000; i++){

                document.writeln(i);

            }        

            

            msPerformance.markAndMeasure("writeLoopEnd", "writeLoopMeasure", "writeLoopBegin");        

            var res = msPerformance.getMeasure("writeLoopMeasure");

            

            alert(res + " ms elepased.");    

        } else {

            document.write("msPerformance isn't available in your browser.")

        }

    }

  
The first thing you have to do is get a reference to the msPerformance
object. To start measuring you need to call the
[mark](http://msdn.microsoft.com/en-us/library/ff975187(v=VS.85).aspx)
function. After marking, you can run the code you want to measure. When
that is done, you need to call the
[markAndMeasure](http://msdn.microsoft.com/en-us/library/ff975188(v=VS.85).aspx)
function. Once the end is marked an measurement is finished, you can get
the results by calling the
[getMeasure](http://msdn.microsoft.com/en-us/library/ff975185(v=VS.85).aspx)
function.  
  
See it in action [here](http://pastehtml.com/view/1cai752.html).  
  
**What about standards?**  
  
You probably noticed by the ms prefix that this isn't part of the
standards yet. It does look like there are efforts being made by the W3C
to get a [performance measurement API into the
standards](http://test.w3.org/webperf/specs/NavigationTiming/) though.  
  
**Is this something you have been waiting for?**
