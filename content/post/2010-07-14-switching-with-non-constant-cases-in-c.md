+++
title = "Switching with non-constant cases in C#"
slug = "2010-07-14-switching-with-non-constant-cases-in-c"
published = 2010-07-14T22:25:00.001000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "ASP.NET", "Reporting", "Tips",]
+++
Last week I came across a scenario where I wanted to switch over
non-constants (aka variables), but while I was compiling I got [Compiler
Error CS0150 (A constant value is
expected)](http://msdn.microsoft.com/en-us/library/6weteh5e(VS.80).aspx).
This is one of those things I always forget. You can't use variables in
your case statements because the C\# compiler doesn't allow you to. It's
very logical though, the compiler forces you to use constants because
otherwise there is no way of knowing there are equal case statements.  
  
<span style="font-weight:bold;">The scenario</span>  
  
Let's say I have an ASP.NET page where the user can input and submit a
value. On the server-side I want to match this value with a value from a
local resource file. Depending on the match I want to execute other
code.  
  
Remember I can't use a switch because the values in the local resource
file are variable.  
  
<span style="font-weight:bold;">Option one: Using else-if
statements</span>  
  
As shown in the code snippet below you can use else-if statements to
search for a match.  
  

       1:  if (input == GetLocalResourceObject("CaseOne").ToString())

       2:  {

       3:      this.ltResult.Text = "Case one matched.";

       4:  }

       5:  else if (input == GetLocalResourceObject("CaseTwo").ToString())

       6:  {

       7:      this.ltResult.Text = "Case two matched.";

       8:  }

       9:  else if (input == GetLocalResourceObject("CaseThree").ToString())

      10:  {

      11:      this.ltResult.Text = "Case three matched.";

      12:  }

      13:  else

      14:  {

      15:      this.ltResult.Text = "No matching case found.";

      16:  }

  
This option has at least two disadvantages:

-   It allows equal conditions (cases) which might have horrible
    consequences.
-   It's ugly.

  
<span style="font-weight:bold;">Option two: Using a dictionary</span>  
  
You can also use a generic dictionary where the keyvaluepairs have a
string as the key and a delegate as the value. Because the code I'm
executing when a match is found is so compact I'm using the simplest
delegate of them all: an [Action
delegate](http://msdn.microsoft.com/en-us/library/system.action.aspx).
An Action delegate takes no parameters and does not return a value.  
  

       1:  Dictionary<string, Action> mappings = new Dictionary<string, Action>()

       2:  {

       3:      { GetLocalResourceObject("CaseOne").ToString(), () => this.ltResult.Text = "Case one matched."},

       4:      { GetLocalResourceObject("CaseTwo").ToString(), () => this.ltResult.Text = "Case two matched."},

       5:      { GetLocalResourceObject("CaseThree").ToString(), () => this.ltResult.Text = "Case three matched."}

       6:  };

       7:   

       8:  if (mappings.ContainsKey(input))

       9:      mappings[input]();

      10:  else

      11:      this.ltResult.Text = "No matching case found.";

  
I think this option is a lot better than the previous one:  

-   This code is elegant, no spaghetti here.
-   And better yet, having equal conditions (cases) is impossible. You
    can't add duplicate keys to a dictionary. If you do, an
    ArgumentException gets thrown at runtime.

  
  
[![](../images/thumbnails/2010-07-14-switching-with-non-constant-cases-in-c-argumentExc.png)](../images/2010-07-14-switching-with-non-constant-cases-in-c-argumentExc.png)  
  
<span style="font-weight:bold;">More options?</span>  
  
Do you know more or better options?
