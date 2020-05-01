+++
title = "Add leading zeros to a number"
slug = "2009-12-07-add-leading-zeros-to-a-number"
published = 2009-12-07T20:21:00.008000+01:00
author = "Jef Claes"
tags = [ ".NET", "Tips",]
+++
Todays post is a very small tip.  
  
I saw the question "How to add leading zeros to a number" on the ASP.NET
forums countless times before. And often the answers provide solutions
that work, but are overkill as well.  
  
The two cleanest methods I know are
[String.Format](http://msdn.microsoft.com/en-us/library/system.string.format.aspx)
and
[PadLeft](http://msdn.microsoft.com/en-us/library/system.string.padleft.aspx).  

  

       1:  Console.WriteLine("Using .ToString()");

       2:  Console.WriteLine(String.Format("{0:0000}", 16));

       3:   

       4:  Console.WriteLine("-------------------");

       5:   

       6:  Console.WriteLine("Using .PadLeft()");

       7:  Console.WriteLine(Convert.ToString(16).PadLeft(4, '0'));

  
You can see the result here.  

  

    //Using .ToString()

    //0016

    //-------------------

    //Using .PadLeft()

    //0016
