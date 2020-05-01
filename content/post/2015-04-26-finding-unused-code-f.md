+++
title = "Finding unused code (F#)"
slug = "2015-04-26-finding-unused-code-f"
published = 2015-04-26T18:06:00.001000+02:00
author = "Jef Claes"
tags = [ "F#",]
+++
Coming from C\#, I'm used to the compiler warning me about unused
variables. Relying on the compiler to help me with [checked exceptions
in F\#](http://www.jefclaes.be/2015/03/checked-errors-in-f.html), I
noticed that unused values (and functions) would go unnoticed. Having
accidentally read earlier that [Haskell has a compiler flag to check for
unused
bindings](https://downloads.haskell.org/~ghc/7.0-latest/docs/html/users_guide/options-sanity.html),
I looked for the F\# equivalent but failed to find it, until Scott
Wlaschin pointed me in [the right
direction](https://downloads.haskell.org/~ghc/7.0-latest/docs/html/users_guide/options-sanity.html).  
  
By using the --warnon:1182 flag, the compiler will warn you about unused
bindings.  
  

[![](../images/thumbnails/2015-04-26-finding-unused-code-f-CompilerFlag.PNG)](../images/2015-04-26-finding-unused-code-f-CompilerFlag.PNG)

  
For example, compiling Paket.Core with this flag enabled, outputs the
following warnings.

  

Looking into these warnings revealed values and functions that can be
deleted, but no apparent bugs. There are also cases where unused
bindings make sense, for example when you pass in a function that does
not use all of its arguments or when pattern matching. In these cases
you can suppress the warning by prefixing the bindings with an
underscore.  
  

A useful compiler feature which strangely enough is opt-in. I plan on
using it from now on.
