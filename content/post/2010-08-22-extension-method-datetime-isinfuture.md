+++
title = "Extension method: DateTime.IsInFuture()"
slug = "2010-08-22-extension-method-datetime-isinfuture"
published = 2010-08-22T13:03:00.004000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET",]
+++
In this post you can find a simple DateTime [extension
method](http://msdn.microsoft.com/en-us/library/bb383977.aspx). The
IsInFuture method simply returns a boolean indicating whether the
DateTime instance is in the future or not.  
  

       1:  public static class DateTimeExtensions

       2:  {

       3:      public static bool IsInFuture(this DateTime dateTime)

       4:      {

       5:          int compareResult = DateTime.Compare(dateTime, DateTime.Now);

       6:   

       7:          return compareResult != -1;

       8:      }

       9:  }

  
You can use it like this..  
  

       1:  DateTime dateTimeInPast = new DateTime(2010, 5, 20);

       2:  DateTime dateTimeInFuture = new DateTime(2025, 11, 20);

       3:   

       4:  Console.WriteLine(dateTimeInPast.IsInFuture()); //Prints False

       5:  Console.WriteLine(dateTimeInFuture.IsInFuture()); //Prints True
