+++
title = "Finding unused code (F#)"
slug = "2015-04-26-finding-unused-code-f"
published = 2015-04-26T18:06:00.001000+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2015/04/finding-unused-code-f.html"
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
  
[![](/post/images/thumbnails/2015-04-26-finding-unused-code-f-CompilerFlag.PNG)](/post/images/2015-04-26-finding-unused-code-f-CompilerFlag.PNG)

For example, compiling Paket.Core with this flag enabled, outputs the
following warnings.

```
1>C:\Paket\src\Paket.Core\Utils.fs(88,9): warning FS1182: The value 'fi' is unused
1>C:\Paket\src\Paket.Core\Utils.fs(361,46): warning FS1182: The value 'econt' is unused
1>C:\Paket\src\Paket.Core\Utils.fs(361,52): warning FS1182: The value 'ccont' is unused
1>C:\Paket\src\Paket.Core\PackageSources.fs(97,25): warning FS1182: The value 'uri' is unused
1>C:\Paket\src\Paket.Core\RemoteDownload.fs(147,18): warning FS1182: The value 'downloaded' is unused
1>C:\Paket\src\Paket.Core\RemoteUpload.fs(71,16): warning FS1182: The value 'whyIsThisNeeded' is unused
1>C:\Paket\src\Paket.Core\RemoteUpload.fs(85,17): warning FS1182: The value 'progressSubscription' is unused
...
```
  
Looking into these warnings revealed values and functions that can be
deleted, but no apparent bugs. There are also cases where unused
bindings make sense, for example when you pass in a function that does
not use all of its arguments or when pattern matching. In these cases
you can suppress the warning by prefixing the bindings with an
underscore.  
  
```fsharp
fun (cont,_econt,_ccont) -> ...
```

A useful compiler feature which strangely enough is opt-in. I plan on
using it from now on.
