+++
title = "Extension method: IEnumerable<DateTime?>.AreChronological()"
slug = "2010-08-22-extension-method-ienumerable-datetime-arechronological"
published = 2010-08-22T13:54:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET",]
+++
In this post you can find an [extension
method](http://msdn.microsoft.com/en-us/library/bb383977.aspx) which
extends IEnumerable&lt;DateTime?&gt;. The AreChronological extension
method tests if the items in the IEnumerable&lt;DateTime?&gt; are in
chronological order.  
  
There are multiple ways you can solve this problem.  
  
<span style="font-weight:bold;">Imperative solution</span>  
  

       1:  public static class DateTimeExtensions

       2:  {     

       3:      public static bool AreChronological(this IEnumerable<DateTime?> dateTimes)

       4:      {

       5:          var prev = (DateTime?)DateTime.MinValue;

       6:   

       7:          foreach (var dateTime in dateTimes)

       8:          {

       9:              if (dateTime != null)

      10:              {

      11:                  if (prev > dateTime)

      12:                  {

      13:                      return false;

      14:                  }

      15:                  prev = dateTime;

      16:              }

      17:          }

      18:   

      19:          return true;

      20:      }

      21:  }

  

<span style="font-weight:bold;">Functional solution</span>  
  
After I finished the imperative solution, I asked [Bart De
Smet](http://community.bartdesmet.net/blogs/bart/Default.aspx) if he
knew a sexier solution. He completely Linqified the solution and came up
with this.  
  

       1:  public static bool AreChronological(this IEnumerable<DateTime?> dateTimes)

       2:  {

       3:      return dateTimes.Where(d => d != null)

       4:                      .Aggregate(new { c = (DateTime?)DateTime.MinValue, b = true },

       5:                                  (a, d) => new { c = d, b = a.b && a.c <= d }).b;

       6:  }

  
  
<span style="font-weight:bold;">Usage</span>  
  
You can use the extension method like this.  
  

       1:  DateTime?[] dateTimesChronological = new DateTime?[] { new DateTime(2010, 5, 15), 

       2:                                                         null, 

       3:                                                         new DateTime(2010, 6, 20) }; 

       4:  DateTime?[] dateTimesNotChronological = new DateTime?[] { new DateTime(2010, 6, 20), 

       5:                                                            null, 

       6:                                                            new DateTime(2010, 5, 15) }; 

       7:   

       8:  Console.WriteLine(dateTimesChronological.AreChronological());

       9:  Console.WriteLine(dateTimesNotChronological.AreChronological());

  

  
<span style="font-weight:bold;">Your opinion</span>  
  
Which solution do you like best? The imperative or the functional
solution? Any ideas on how I could improve this code?
