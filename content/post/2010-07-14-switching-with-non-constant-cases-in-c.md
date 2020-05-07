+++
title = "Switching with non-constant cases in C#"
slug = "2010-07-14-switching-with-non-constant-cases-in-c"
published = 2010-07-14T22:25:00.001000+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2010/07/switching-with-non-constant-cases-in-c.html"
+++
Last week I came across a scenario where I wanted to switch over
non-constants (aka variables), but while I was compiling I got [Compiler
Error CS0150 (A constant value is
expected)](http://msdn.microsoft.com/en-us/library/6weteh5e(VS.80).aspx).
This is one of those things I always forget. You can't use variables in
your case statements because the C\# compiler doesn't allow you to. It's
very logical though, the compiler forces you to use constants because
otherwise there is no way of knowing there are equal case statements.  
  
### The scenario  
  
Let's say I have an ASP.NET page where the user can input and submit a
value. On the server-side I want to match this value with a value from a
local resource file. Depending on the match I want to execute other
code.  
  
Remember I can't use a switch because the values in the local resource
file are variable.  
  
### Option one: Using conditional statements 
  
As shown in the code snippet below you can use else-if statements to
search for a match.  

```csharp
if (input == GetLocalResourceObject("CaseOne").ToString()) {
      this.ltResult.Text = "Case one matched.";
} else if (input == GetLocalResourceObject("CaseTwo").ToString()) {
      this.ltResult.Text = "Case two matched.";
} else if (input == GetLocalResourceObject("CaseThree").ToString()) {
      this.ltResult.Text = "Case three matched.";
} else {
      this.ltResult.Text = "No matching case found.";
}
```
  
This option has at least two disadvantages:
- It allows equal conditions (cases) which might have horrible consequences.
- It's ugly.

### Option two: Using a dictionary  
  
You can also use a generic dictionary where the pairs have a
string as the key and a delegate as the value. Because the code I'm
executing when a match is found is so compact I'm using the simplest
delegate of them all: an [Action
delegate](http://msdn.microsoft.com/en-us/library/system.action.aspx).
An Action delegate takes no parameters and does not return a value.  
  
```cs
Dictionary<string, Action> mappings = new Dictionary<string, Action>() {
      { GetLocalResourceObject("CaseOne").ToString(), () => this.ltResult.Text = "Case one matched."},
      { GetLocalResourceObject("CaseTwo").ToString(), () => this.ltResult.Text = "Case two matched."},
      { GetLocalResourceObject("CaseThree").ToString(), () => this.ltResult.Text = "Case three matched."}
};

if (mappings.ContainsKey(input)) {
      mappings[input]();
} else {
      this.ltResult.Text = "No matching case found.";
}
```
  
I think this option is a lot better than the previous one:  
- This code is elegant, no spaghetti here.
- And better yet, having equal conditions (cases) is impossible. You can't add duplicate keys to a dictionary. If you do, an `ArgumentException` gets thrown at runtime.
  
[![](/post/images/thumbnails/2010-07-14-switching-with-non-constant-cases-in-c-argumentExc.png)](/post/images/2010-07-14-switching-with-non-constant-cases-in-c-argumentExc.png)  