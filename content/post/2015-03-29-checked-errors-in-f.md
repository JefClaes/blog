+++
title = "Checked errors in F#"
slug = "2015-03-29-checked-errors-in-f"
published = 2015-03-29T17:19:00+02:00
author = "Jef Claes"
tags = [ "code"]
url = "2015/03/checked-errors-in-f.html"
+++
In the land of C\#, exceptions are king. [By
definition](https://msdn.microsoft.com/en-us/library/ms173160(v=vs.80).aspx)
exceptions help us deal with "unexpected or exceptional situations that
arise while a program is running". In that regard, we're often
optimistic, overoptimistic. Most code bases treat errors as exceptional
while they're often commonplace. We are so confident about the
likelyhood of things going wrong, we don't even feel the need to
communicate to consumers what might go wrong. If a consumer of a method
wants to know what exceptions might be thrown, he needs to resort to
reading the documentation (or source) and hope it's up-to-date.  
  
Java on the other hand has a concept of unchecked and checked
exceptions. Unchecked exceptions are exceptions that are caused by a
programming mistake and should be left unhandled (null reference,
division by zero, argument out of range etc); while checked exceptions
are exceptions that your program might be able to recover from. They
become part of the method signature and the Java compiler forces
consumers to handle them explicitly.  
  
While checked exceptions might bloat the method's contract and enlarge
the API surface area, they might have every right to. Dealing with
errors is an important part of programming. Having discoverable errors
which require thoughtful care, should improve overall quality. Having
said that, it also requires careful consideration from the designer to
decide what's truly exceptional.  
  
Coming up with something that can compete with the mechanics of checked
exceptions in C\# seems to be impossible. We could return a result with
an error from a method, but the compiler doesn't force you to do
anything with that result.  
  
F\# on the other hand doesn't allow for the result of an expression to
be thrown away. That is, unless you explicitly ignore it, or bind it and
leave it unused.  
  
Let's look at an example. We start by defining two discriminated unions.
The first type defines a generic result; it can either be success or
failure. The second type defines all the errors that can be returned
after deleting a file.  

```fsharp
type Result<'TSuccess,'TError> = 
    | Success of 'TSuccess
    | Error of 'TError

type DeleteFileError = 
    | FileInUse 
    | OpenHandle 
    | UnauthorizedAccess 
```

Then we write a function that deletes a file, but instead of throwing
exceptions when an error occurs, it returns a specific error. When no
errors occur, success is returned.

```fsharp
let deleteFile name =
	match name with
	| "inuse.txt" -> Error(FileInUse)
	| "openhandle.txt" -> Error(OpenHandle)
	| "unauthorizedaccess.txt" -> Error(UnauthorizedAccess)
	| _ -> Success()
``` 

When I now use this function, the compiler will tell me that it has a
return value which needs to ignored or binded.

```fsharp
deleteFile "inuse.txt"

// This expression should have type 'unit', but has type 'Result<unit,DeleteFileError>'. 
// Use 'ignore' to discard the result of the expression, or 'let' to bind the result to a name.	

deleteFile "inuse.txt" |> ignore
let res = deleteFile "inuse.txt"
```

While ignoring a result stands out, an unused binding is easier to go
unnoticed. I wish the F\# compiler had a flag to detect unused
bindings.  
  
Assuming I don't ingore the result, I can use pattern matching to
address each error specifically.

```fsharp
let deleteFileAggressively name retries =
	let rec deleteFileAggressivelyIn name retries retry =
		match deleteFile name with	
		| Success _ -> ()
		| Error(FileInUse) | Error(OpenHandle) ->
			match retry <= retries with
			| true ->
				Thread.Sleep 1000
				printfn "Trying to delete file: retry %A of %A" retry retries
				deleteFileAggressivelyIn name retries (retry + 1)
			| false -> printfn "Failed to delete file agressively"
		| Error(UnauthorizedAccess) -> printfn "Unauthorized access"
			
	deleteFileAggressivelyIn name retries 1

deleteFileAggressively "inuse.txt" 5
```
  

By not including a wildcard pattern, extending the contract by adding
errors will introduce a breaking change. We'll have to consider what to
do with newly added errors.  
  
For example, if I add the error PathTooLong, the compiler shows me this
warning.  

```
// Incomplete pattern matches on this expression. 
// For example, the value 'Error (PathTooLong (_))' may indicate a case not covered by the pattern(s).
```

In summary, it might be more safe to be a bit less optimistic when it
comes to errors. Instead of throwing exceptions, making errors part of
the public interface, communicating errors explicitly, and handing
responsibility on what to do with the error to the caller, might lead to
more robust systems. While this can be achieved with C\#, the mechanics
are error-prone. Expressions and pattern matching make that F\# allows
for stronger, yet still not ideal, mechanics.
