+++
title = "Paper notes: A Study and Toolkit for Asynchronous Programming in C#"
slug = "2014-06-08-paper-notes-a-study-and-toolkit-for-asynchronous-programming-in-c"
published = 2014-06-08T18:33:00.001000+02:00
author = "Jef Claes"
tags = [ ".NET",]
+++
The .NET framework mainly provides two models for asynchronous
programming: (1) the Asynchronous Programming Model (APM), that uses
callbacks, and (2) the Task Asynchronous Pattern (TAP), that uses Tasks,
which are similar to the concept of futures.  
  
The Task represents the operation in progress, and its future result.
The Task can be (1) queried for the status of the operation, (2)
synchronized upon to wait for the result of the operation, or (3) set up
with a continuation that resumes in the background when the task
completes.  
  
When a method has the async keyword modifier in its signature, the await
keyword can be used to define pausing points. The code following the
await expression can be considered a continuation of the method, exactly
like the callback that needs to be supplied explicitly when using APM or
plain TAP.  
  
**Do Developers Misuse async/await?**  

1.  One in five async methods violate the principle that an async method
    should be awaitable unless it is the top level event handler.
2.  Adding the async modifier comes at a price: the compiler generates
    some code in every async method and generated code complicates the
    control flow which results in decreased performance. There is no
    need to use async/await in 14% of async methods.
3.  1 out of 5 apps miss opportunities in at least one async method to
    increase asynchronicity.
4.  99% of the time, developers did not use ConfigureAwait(false) where
    this was needed.

The async/await feature is a powerful abstraction. asynchronous methods
are more complicated than regular methods in three ways. (1) Control
flow of asynchronous methods. Control is returned to the caller when
awaiting, and the continuation is resumed later on. (2) Exception
handling. Exceptions thrown in asynchronous methods are automatically
captured and returned through the Task. The exception is then re-thrown
when the Task is awaited. (3) Non-trivial concurrent behavior.  
  
Each of these is a leak in the abstraction, which requires an
understanding of the underlying technology - which developers do not yet
seem to grasp.  
  
Another problem might simply be the naming of the feature: asynchronous
methods. However, the first part of the method executes synchronously,
and possible the continuations do as well. Therefore, the name
asynchronous method might be misleading: the term pauseable could be
more appropriate.  
  
[Source](http://swerl.tudelft.nl/twiki/pub/Main/TechnicalReports/TUD-SERG-2013-016.pdf)
