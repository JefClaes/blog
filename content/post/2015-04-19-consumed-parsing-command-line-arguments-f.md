+++
title = "Consumed: Parsing command line arguments (F#)"
slug = "2015-04-19-consumed-parsing-command-line-arguments-f"
published = 2015-04-19T16:54:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2015/04/parsing-command-line-arguments-with-f.html"
+++
Last year, I set out to write my first node.js application; a small web
application for keeping lists of [everything I
consume](http://www.jefclaes.be/2015/01/consumed-in-2014.html). I had
something working pretty quickly, deployed it to Heroku and still find
myself using it today. Since there's very little use for having it
running on a server, and because I wanted something to toy with getting
better at F\#, I decided to port it to an F\# console application.  
  
With the UI gone, I need to resort to passing in arguments from the
command line to have my program transform those into valid commands and
queries that can be executed.  
  
The set of commands and queries is limited; consume an item, remove an
item and query a list of everything consumed.

```fsharp
module Contracts =

    type Command =
        | Consume of id : string * description : string * url : string
        | Remove of id : string

    type Query =
        | List
```

Ideally I go from a sequence of strings to a typed command or query.
However, when the list of arguments can't be parsed, I expect a result
telling me what failed just the same.

```fsharp
type Result<'TSuccess,'TFailure> = 
	| Success of 'TSuccess
	| Failure of 'TFailure
	
type ParserFailure =
	| ArgumentsMissing 
	| KeyMissing of string
	| KeyLooksLikeValue of string
	| NotFound
	
[<Test>]
let ``Parsing consume command``() =  
    let expected = Consume("2", "The Dark Tower", "http://thedarktower.com")
    let actual = parse [| "--n"; "consume"; "--id"; "2"; "--d"; "The Dark Tower"; "--u"; "http://thedarktower.com"; |]
    match actual with
    | Success(Command(x)) -> x |> should equal expected
    | _ -> Assert.Fail() 
```
  
Since we need the name to identify the command or query, I expect the
input to have at least two arguments.

```fsharp
let ensureEnoughElements input =
    match ( input |> Seq.length > 1 ) with
    | true -> Success input 
    | false -> Failure ArgumentsMissing
```
    
Arguments come in pairs; a key and a value. My first thought was to
build a map here, but that made key validation, key transformations and
pattern matching harder.  I can actually get away with transforming the
input to a sequence of tuples.

```fsharp
let pair input =    
	input 
	|> Seq.pairwise   
	|> Seq.mapi (fun i x -> if i % 2 = 0 then Some(x) else None)
	|> Seq.choose id      
```
  
Hoping to avoid some mistakes in the input, basic validation makes sure
the keys actually look like keys, instead of a value. Keys start with a
single or double dash.

```fsharp
let ensureKeysDontLookLikeValue ( arguments : seq<string * string> ) =
	let looksLikeValue = 
		arguments 
		|> Seq.tryFind ( fun ( k, v ) -> not (k.StartsWith("-") || k.StartsWith("--")) )
	match looksLikeValue with
	| Some ( key, value ) -> Failure(KeyLooksLikeValue key)
	| None -> Success arguments 
```
  
Once that validation is out of the way, I strip away those dashes. That
should make the two last steps easier.

```fsharp
let stripKeys ( arguments : seq<string * string> ) =        
    arguments |> Seq.map (fun ( k, v ) -> ( k.Replace("-", "").ToLower(), v ))
```

The name is required, so I wrote a small function that makes sure a
specific key exists.

```fsharp
let ensureKeyExists key arguments =      
	match arguments |> Seq.exists (fun ( k, v ) -> k = key ) with
	| true -> Success arguments
	| false -> Failure(KeyMissing key)
```

Now that I have a list of arguments,  I can map them into a typed
command or query using pattern matching.

```fsharp
let toCommandOrQuery arguments =
	match arguments |> Seq.toList with
	| [ ( "n", "consume" ); ("id", id ); ( "d", description ); ( "u", url ) ] ->
	Success(Command(Consume(id, description, url)))
	| [ ( "n", "remove" ); ( "id" , id ) ] ->
	Success(Command(Remove(id)))
	| [ ( "n", "list" )] ->
	Success(Query(List))
	| _ -> Failure NotFound 
```
  
Having written all these small functions, I can simply compose them
using [Scott Wlaschin](https://twitter.com/scottwlaschin)'s [Railway
oriented
programmming](http://fsharpforfunandprofit.com/posts/recipe-part2/).  

```fsharp
let result = 
	input 
	|> ensureEnoughElements
	>>= switch pair
	>>= ensureKeysDontLookLikeValue
	>>= switch stripKeys
	>>= ensureKeyExists "n"
	>>= toCommandOrQuery
```

This is far from a generic command line parser, but it's simple and
covers my needs.  
  
Next up, executing those commands and queries, and printing feedback.
