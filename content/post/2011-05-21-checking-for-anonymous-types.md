+++
title = "Checking for anonymous types"
slug = "2011-05-21-checking-for-anonymous-types"
published = 2011-05-21T18:00:00.005000+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2011/05/checking-for-anonymous-types.html"
+++
Because I blogged about anonymous types [last
month](https://www.jefclaes.be/2011/04/anonymous-type-equality-follow-up.html), I thought following method would also make an interesting post.  
  
```csharp
private static bool IsAnonymousType(Type type) {
    Debug.Assert(type != null, "Type should not be null");

    // HACK: The only way to detect anonymous types right now.
    return Attribute.IsDefined(type, typeof(CompilerGeneratedAttribute), false)
            && type.IsGenericType 
            && type.Name.Contains("AnonymousType")
            && (type.Name.StartsWith("<>", StringComparison.OrdinalIgnoreCase) ||
                type.Name.StartsWith("VB$", StringComparison.OrdinalIgnoreCase))
            && (type.Attributes & TypeAttributes.NotPublic) == TypeAttributes.NotPublic;
}
```
  
For a type to be anonymous:
- It should be marked with the [CompilerGenerated](http://msdn.microsoft.com/en-us/library/system.runtime.compilerservices.compilergeneratedattribute.aspx) attribute
- It should be a generic type
- Its name should contain "AnonymousType"
- Its name should start with "&lt;&gt;" or "VB$"
- It shouldn't be publicly accessible

A little fun fact is that the VB and C\# compiler generate different
type names. The C\# compiler makes the type name start with "&lt;&gt;"
and the VB compiler uses "VB$". Both smart safeguards, because the
compiler doesn't allow us to use "&lt;&gt;" or "$" while defining type
names. I find the C\# way a tad more elegant though.  
  
I stumbled upon this beauty while browsing the [ASP.NET MVC source] (http://aspnet.codeplex.com/) (System.Web.Helpers.ObjectVisitor).
Because there is no direct way to detect anonymous types yet, I'm pretty
sure this is the best implementation out there.
