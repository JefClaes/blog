+++
title = "Consumed: Handling commands (F#)"
slug = "2015-05-17-consumed-handling-commands-f"
published = 2015-05-17T17:51:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2015/05/consumed-handling-commands-f.html"
+++
As [I wrote
earlier](http://www.jefclaes.be/2015/04/parsing-command-line-arguments-with-f.html),
I've been working on porting a node.js web application to an F\# console
application. It's an application I wrote to learn node.js but still use
today to keep track of [all the things I
consume](http://www.jefclaes.be/2015/01/consumed-in-2014.html).  
  
The application is able to consume an item, to remove a consumed item
and to query all consumed items.  
  
In the previous post, I parsed command line arguments into typed
commands and queries. Today, I'll look at handling the two commands.

```fsharp
type Command =
	| Consume of data : ConsumeData
	| Remove of data : RemoveData
and ConsumeData =  { Id : string; Category : string; Description : string; Url : string }
and RemoveData = { Id : string; }
```

I've refactored the command discriminated union to contain records with
data that go along with the command - I found that this makes for more
discoverable and refactor-friendly deconstruction later on.  
  
### Validation  
  
Before we do anything with the command, we need to make sure it passes
basic validation. The validate function takes a command, and returns a
success or failure result. Validation can fail because an argument is
empty, its structure is invalid or it's out of range. Inside the
function we match the command discriminated union with each case,
validate the data and return a result.

```fsharp
type Result<'TSuccess,'TFailure> =
	| Success of 'TSuccess
	| Failure of 'TFailure

 type ValidationFailure =
        | ArgumentEmpty of string
        | ArgumentStructure of string  
        | ArgumentOutOfRange of string

type HandlingFailure =
	| Validation of ValidationFailure
	
let succeeds s = Success s
let validationFails f = Failure(Validation(f))
	
let validate cmd =
	match cmd with
	| Consume data -> 
	    (
	        if data.Id = "" then validationFails(ArgumentEmpty("id"))
	        else if data.Category = "" then validationFails(ArgumentEmpty("category"))
	        else if data.Description = "" then validationFails(ArgumentEmpty("description"))
	        else if data.Url = "" then validationFails(ArgumentEmpty("url"))
	        else if not ( [| "book"; "movie" |] |> Seq.exists (fun x -> x.Equals(data.Category, StringComparison.OrdinalIgnoreCase) ) ) then validationFails(ArgumentOutOfRange("category"))         
	        else if not ( data.Url.Contains("http://") || data.Url.Contains("https://") ) then validationFails(ArgumentStructure("url"))
	        else succeeds cmd
	    )
	| Remove data -> 
	    (
	        if data.Id = "" then validationFails(ArgumentEmpty("id"))
	        else succeeds cmd
	    )
```

### Producing events
  
Having validated the command, we can start thinking about doing
something useful. I want the command handlers to be pure, to be able to
focus on computation, without having to worry about side effects.  
  
Since the node.js web application stores its data in the form of events,
this one will too. I can now migrate the existing event store to a
simple text file living in my Dropbox, for then to drop the existing
Postgres database.  
  
This means that command handlers will need to produce events.  

```fsharp
type Event =
	| Consumed of data : ConsumedData
	| Removed of data : RemovedData
and ConsumedData = { Timestamp : DateTime; Id : string; Category : string; Description : string; Url : string }
and RemovedData = { Timestamp : DateTime; Id : string }

type CmdResult = | Event of stream : string * event : Event
```

### Dependencies  
  
Looking at the tests the command handlers need to satisfy, we know
that a command handler depends on the system time and the eventstore.  
  
The dependency on time is just a function that takes no arguments and
returns a datetime.  

```fsharp
unit -> DateTime
```  

An implementation could look like this.  

```fsharp
let thetime() = DateTime.UtcNow
```  

Reading an event stream is a function that takes a stream name and
returns an event stream.

```fsharp
type EventStream =
	| NotExists of name : string
	| Exists of name : string * events : seq<Event>

string -> EventStream
```

Implementing a naïve event store takes more than one line on code.  
  
### An eventstore  
  
This implementation stores events in a text file. When an event is
stored, it gets serialized to JSON for then to be appended to a text
file. When reading a stream it will read all events from disk,
deserialize them to then filter by stream name before returning it as an
event stream - it's not exactly web scale.

```fsharp
type StoredEvent =  { Stream : string; Body : Event  }

let store path stream e =
        let serialize e = JsonConvert.SerializeObject e

        let writeToDisk ( line : string ) = 
            use wr = new StreamWriter(path, true)
            wr.WriteLine(line)
        
        let eventOnDisk = { Stream = stream; Body = e } 

        serialize eventOnDisk |> writeToDisk 
        Success eventOnDisk

let read path stream =
	let deserialize x = JsonConvert.DeserializeObject<StoredEvent>(x)

	let readFromDisk = File.ReadAllLines path |> Seq.map deserialize

	let eventsFromDisk =
		match stream with
		| "$all" -> readFromDisk
		| _ -> readFromDisk |> Seq.filter (fun e -> e.Stream = stream)

	match eventsFromDisk |> Seq.isEmpty with
	| true -> EventStream.NotExists stream
	| false -> EventStream.Exists (stream, eventsFromDisk |> Seq.map (fun e -> e.Body))
```

The signature for reading a stream doesn't satisfy the signature we
defined earlier though. We can satisfy it by creating a [partially
applied function](http://fsharpforfunandprofit.com/posts/partial-application/).

```fsharp
// path:string -> stream:string -> EventStream to string -> EventStream

let read stream = read "eventstore.txt" stream
```

### Handlers  

Handlers focus on pure computation, they just need to return an event
or a failure.  
  
We can only consume an item once, and we can only remove items that
exist. It shouldn't be possible to consume items that have been removed.
There isn't much needed on the inside to cover these use cases.  
  
We inject the event store and time dependencies by passing in the
relevant functions - since I'm already using this function further on in
program.fs, the compiler can infer the signatures, no need to explicitly
state the signatures I defined earlier.

```fsharp
type CommandFailure =
	| ItemAlreadyConsumed
	| ItemDoesNotExist

type HandlingFailure =
	| Validation of ValidationFailure
	| Command of CommandFailure
	
let commandFails f = Failure(Command(f))

let handle read thetime cmd =
	match cmd with
	| Command.Consume data ->
	    let stream = sprintf "consumeditem/%s" data.Id
	
	    match read stream with
	    | EventStream.Exists _ ->
	        commandFails ItemAlreadyConsumed
	    | EventStream.NotExists stream -> 
	        succeeds ( Event ( stream, Consumed { Timestamp = thetime(); Id = data.Id; Category = data.Category; Description = data.Description; Url = data.Url } ) )
	| Command.Remove data ->
	    let stream = sprintf "consumeditem/%s" data.Id
	
	    match read stream with
	    | EventStream.NotExists ( _ ) ->
	        commandFails ItemDoesNotExist
	    | EventStream.Exists ( stream , _ ) ->
	        succeeds ( Event ( stream, Removed { Timestamp = thetime(); Id = data.Id } ) )
```
  
### Side effects  

So far we have been able to avoid intentional side effects - we did
introduce functions that might have accidental side effects (reading
from disk and reading the system time ). It would be nice to be able to
restart the application without losing all state, so we need to take the
result the command produced and persist it. A small function takes care
of matching each result to invoke the relevant side effect. So far, we
only want to store events. With this, we successfully isolated side
effects to one small function.

```fsharp
let sideEffects store input =
	match input with
	| Event ( stream, event ) -> store stream event
```

### Putting it all together  
  
By now, we can validate commands, handle them and take care of their
side effects. We can now compose those pieces together using [Railway
Oriented
Programming](http://fsharpforfunandprofit.com/posts/recipe-part2/) and
invoke the pipeline. The output gets matched, so we can print something
relevant for the user to see.

```fsharp
let read stream = read path stream
let handleCommand cmd = 
	cmd 
	|> validate
	>>= handle read thetime 
	>>= switch ( sideEffects (store path) )

match handleCommand cmd with
| Success e 
	-> printfn "Yay! Something happened = %A" e
| Failure(Command(ItemAlreadyConsumed)) 
	-> printfn "Item was already consumed"
| Failure(Command(ItemDoesNotExist)) 
	-> printfn "Item does not exist"
| Failure(Validation(ArgumentEmpty x)) 
	-> printfn "Argument empty = %A" x
| Failure(Validation(ArgumentStructure x)) 
	-> printfn "Argument structure invalid = %A" x
| Failure(Validation(ArgumentOutOfRange x)) 
	-> printfn "Argument out of range = %A" x
```

Next time, we'll look at implementing queries.
