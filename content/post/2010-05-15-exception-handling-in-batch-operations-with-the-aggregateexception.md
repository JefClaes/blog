+++
title = "Exception handling in batch operations with the AggregateException"
slug = "2010-05-15-exception-handling-in-batch-operations-with-the-aggregateexception"
published = 2010-05-15T18:34:00.001000+02:00
author = "Jef Claes"
tags = [ ".NET", "Best Practices",]
+++
Doing batch operations and elegantly handling exceptions is a problem
which every developer has faced before. In .NET 3.5 or older there is no
out-of-the-box solution to handle exceptions in these types of
scenarios, without being inconsistent to the normal flow of exception
handling. .NET 4 introduces the
[AggregateException](http://msdn.microsoft.com/en-us/library/system.aggregateexception.aspx);
an exception representing multiple exceptions. The AggregateException
was introduced in the first place to be used with the [parallel
framework](http://msdn.microsoft.com/en-us/concurrency/default.aspx),
but it can be used in other scenarios as well, such as batch
operations.  
  
<span style="font-weight:bold;">Take a look at the following
example..</span>  
  
I have a single action which I want to peform in batch. This single
action might throw some exceptions.  

  

       1:  private static void ExecuteSingleAction(int i)

       2:  {

       3:       if (i == 5)            

       4:            throw new ArgumentNullException("You forgot an argument.");            

       5:       if (i == 18)

       6:            throw new ArgumentException("This argument doesn't make sense.");              

       7:  }

  
Most of the exceptions the single action might throw shouldn't break my
whole batch operation. While I'm executing the single actions I catch
the exceptions which shouldn't break the batch operation and hold them
in a list of exceptions. The AggregateException has a public constructor
taking an IEnumerable of exceptions. If I catch some exceptions while
executing the single action I throw an AggregateException passing in
that list of exceptions to its constructor.  

  

       1:  private static void ExecuteBatch()

       2:  {

       3:       List<Exception> exceptions = new List<Exception>();

       4:             

       5:       for (int i = 0; i < 100; i++)

       6:       {

       7:            try

       8:            {

       9:                 ExecuteSingleAction(i);

      10:            }

      11:            catch (ArgumentNullException nullRefEx)

      12:            {

      13:                 exceptions.Add(nullRefEx);

      14:            }

      15:            catch (ArgumentException argumentEx)

      16:            {

      17:                 exceptions.Add(argumentEx);

      18:            }             

      19:        }

      20:   

      21:        if (exceptions.Count > 0)           

      22:             throw new AggregateException(exceptions);            

      23:   }

  
In the front-end I can catch the AggregateException, run over its
[InnerExceptions](http://msdn.microsoft.com/en-us/library/system.aggregateexception.innerexceptions(v=VS.100).aspx)
and act based on the type of exception.  

  

       1:  static void Main(string[] args)

       2:  {

       3:       try

       4:       {

       5:            ExecuteBatch();

       6:       }

       7:       catch (AggregateException aggEx)

       8:       {

       9:            foreach(Exception ex in aggEx.InnerExceptions)

      10:            {                  

      11:                 Console.WriteLine(ex.Message);

      12:   

      13:                 if (ex is ArgumentNullException)

      14:                 {

      15:                      //Do something

      16:                 }

      17:                 if (ex is ArgumentException)

      18:                 {

      19:                     //Do something else

      20:                 }

      21:              }

      22:       }

      23:   

      24:       Console.ReadLine();

      25:  }

  
  
The result looks like this.  
  
[![](/post/images/thumbnails/2010-05-15-exception-handling-in-batch-operations-with-the-aggregateexception-ResultAggregateException.png)](/post/images/2010-05-15-exception-handling-in-batch-operations-with-the-aggregateexception-ResultAggregateException.png)  
  
<span style="font-weight:bold;">More scenario's?</span>  
  
Can you imagine other scenarios where the AggregateException might be
able to add some value?  
  
<span style="font-style:italic;">Related post: [Handling the
AggregateException](http://jclaes.blogspot.com/2010/05/handling-aggregateexception.html)</span>
