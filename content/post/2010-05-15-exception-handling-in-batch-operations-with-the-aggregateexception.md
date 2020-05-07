+++
title = "Exception handling in batch operations with the AggregateException"
slug = "2010-05-15-exception-handling-in-batch-operations-with-the-aggregateexception"
published = 2010-05-15T18:34:00.001000+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2010/05/exception-handling-in-batch-operations.html"
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
  
**Take a look at the following example..**
  
I have a single action which I want to peform in batch. This single
action might throw some exceptions.  

```csharp
private static void ExecuteSingleAction(int i)
{
      if (i == 5)            
            throw new ArgumentNullException("You forgot an argument.");       
      if (i == 18)
            throw new ArgumentException("This argument doesn't make sense.");
}
```
  
Most of the exceptions the single action might throw shouldn't break my
whole batch operation. While I'm executing the single actions I catch
the exceptions which shouldn't break the batch operation and hold them
in a list of exceptions. The `AggregateException` has a public constructor
taking an `IEnumerable` of exceptions. If I catch some exceptions while
executing the single action I throw an `AggregateException` passing in
that list of exceptions to its constructor.  

```csharp
private static void ExecuteBatch()
{
      List<Exception> exceptions = new List<Exception>();
      
      for (int i = 0; i < 100; i++)
      {
            try
            {
                  ExecuteSingleAction(i);
            }
            catch (ArgumentNullException nullRefEx)
            {
                  exceptions.Add(nullRefEx);
            }
            catch (ArgumentException argumentEx)
            {
                  exceptions.Add(argumentEx);
            }             
      }

      if (exceptions.Count > 0)           
            throw new AggregateException(exceptions);            
}
```
  
In the front-end I can catch the `AggregateException`, run over its
[InnerExceptions](http://msdn.microsoft.com/en-us/library/system.aggregateexception.innerexceptions(v=VS.100).aspx)
and act based on the type of exception.  

```csharp
static void Main(string[] args)
{
      try
      {
            ExecuteBatch();
      }
      catch (AggregateException aggEx)
      {
            foreach(Exception ex in aggEx.InnerExceptions)
            {                  
                  Console.WriteLine(ex.Message);

                  if (ex is ArgumentNullException)
                  {
                        //Do something
                  }

                  if (ex is ArgumentException)
                  {
                        //Do something else
                  }
            }
      }

      Console.ReadLine();
}
```
  
  
The result looks like this.  
  
[![](/post/images/thumbnails/2010-05-15-exception-handling-in-batch-operations-with-the-aggregateexception-ResultAggregateException.png)](/post/images/2010-05-15-exception-handling-in-batch-operations-with-the-aggregateexception-ResultAggregateException.png)  
    
Can you imagine other scenarios where the `AggregateException` might be
able to add some value?  
  
Related post: [Handling the AggregateException](https://www.jefclaes.be/2010/05/handling-aggregateexception.html)</span>
