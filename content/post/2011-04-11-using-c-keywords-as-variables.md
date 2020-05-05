+++
title = "Using C# keywords as variables"
slug = "2011-04-11-using-c-keywords-as-variables"
published = 2011-04-11T19:00:00.002000+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2011/04/using-c-keywords-as-variables.html"
+++
Hold it, don't shoot me. I know this would be an awful practice, but it
is an interesting C\# compiler quirk nonetheless.  

> Keywords are predefined reserved identifiers that have special
> meanings to the compiler. They cannot be used as identifiers in your
> program unless they include @ as a prefix. For example, @if is a legal
> identifier but if is not because it is a keyword.

```csharp
static void Main(string[] args) {           
    var @if = "oh my..";

    Console.WriteLine(@if);
}
```

```
========== Build: 1 succeeded or up-to-date, 0 failed, 0 skipped ==========
```