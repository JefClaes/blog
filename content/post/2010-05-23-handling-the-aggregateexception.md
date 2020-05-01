+++
title = "Handling the AggregateException"
slug = "2010-05-23-handling-the-aggregateexception"
published = 2010-05-23T13:10:00.023000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "Tips",]
+++
Last week I showed you how you can use the AggregateException to apply
consistent exception handling in batch operations. You can find that
post
[here](http://jclaes.blogspot.com/2010/05/exception-handling-in-batch-operations.html).  
  
[Bart De Smet](http://bartdesmet.net/blogs/bart/) read that post and
pointed out that I should check out the Handle method of the
AggregateException.  
  
<span style="font-weight:bold;">The Handle method</span>  
  
As found in the [MSDN
documentation](http://msdn.microsoft.com/en-us/library/system.aggregateexception.handle.aspx).  
  
Description  

> Invokes a handler on each Exception contained by this
> AggregateException.

  
Parameters  

> System.Func&lt;Exception, Boolean&gt; predicate  
> The predicate to execute for each exception. The predicate accepts as
> an argument the Exception to be processed and returns a Boolean to
> indicate whether the exception was handled.

  
Remarks  

> Each invocation of the predicate returns true or false to indicate
> whether the Exception was handled. After all invocations, if any
> exceptions went unhandled, all unhandled exceptions will be put into a
> new AggregateException which will be thrown. Otherwise, the Handle
> method simply returns. If any invocations of the predicate throws an
> exception, it will halt the processing of any more exceptions and
> immediately propagate the thrown exception as-is.

  
<span style="font-weight:bold;">In practice</span>  
  
I refactored the example in [my previous
post](http://jclaes.blogspot.com/2010/05/exception-handling-in-batch-operations.html)
to make use of the Handle method.  

  

       1:  static void Main(string[] args)

       2:  {

       3:       try

       4:       {

       5:            ExecuteBatch();

       6:       }

       7:       catch (AggregateException aggEx)

       8:       {

       9:            aggEx.Handle(HandleBatchExceptions);

      10:       }

      11:   

      12:       Console.ReadLine();

      13:  }

  
I'm passing a [Func&lt;T, TResult&gt;
delegate](http://msdn.microsoft.com/en-us/library/bb549151.aspx) to the
Handle method. In this delegate I decide whether I'm handling the
exception or not. If I handle the exception, I return true, else I
return false.  

  

       1:  private static bool HandleBatchExceptions(Exception exceptionToHandle)

       2:  {

       3:       if (exceptionToHandle is ArgumentNullException)

       4:       {

       5:            //I'm handling the ArgumentNullException.

       6:            Console.WriteLine("Handling the ArgumentNullException.");

       7:            //I handled this Exception, return true.

       8:            return true;

       9:       }

      10:       else

      11:       {

      12:            //I'm only handling ArgumentNullExceptions.

      13:            Console.WriteLine(string.Format("I'm not handling the {0}.", exceptionToHandle.GetType()));

      14:            //I didn't handle this Exception, return false.

      15:            return false;

      16:       }          

      17:  }

  
When we run this example a new AggregateException is thrown with the
exceptions I didn't handle.  
  
[![](/post/images/thumbnails/2010-05-23-handling-the-aggregateexception-ConsoleOut.bmp)](/post/images/2010-05-23-handling-the-aggregateexception-ConsoleOut.bmp)  
[![](/post/images/thumbnails/2010-05-23-handling-the-aggregateexception-Rethrown.bmp)](/post/images/2010-05-23-handling-the-aggregateexception-Rethrown.bmp)  
  
<span style="font-weight:bold;">Conclusion</span>  
  
Make use of the Handle method to run over each InnerException and decide
which exception you want to handle or not. The exceptions you didn't
handle are automatically wrapped in a new AggregateException which gets
rethrown.
