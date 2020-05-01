+++
title = "Consumed: Queries and projections (F#)"
slug = "2015-05-24-consumed-queries-and-projections-f"
published = 2015-05-24T18:00:00+02:00
author = "Jef Claes"
tags = [ "code"]
url = "consumed-queries-and-projections-f.html"
+++
This is the third post in my series on porting a node.js application to
an F\# application.  
  
So far, I've looked at [parsing command line
arguments](http://www.jefclaes.be/2015/04/parsing-command-line-arguments-with-f.html),
[handling commands and storing
events](http://www.jefclaes.be/2015/05/consumed-handling-commands-f.html).
Today, I want to project those events into something useful that can be
formatted and printed to the console.  
  
In the original application, I only had a single query. The result of
this query lists all items consumed grouped by category, sorted
chronologically.

```fsharp
type Query = | List

type ListResult = { Categories : seq<Category> }
       and Category = { Name : string; Items : seq<Item>; }
       and Item = { Id : string; Timestamp : DateTime; Category : string; Description: string; Url: string }
```

Handling the query is done in a similar fashion to handling commands.
The handle function matches each query and has a dependency on the event
store.  
  
Where C\# requires a bit of plumbing to get declarative projections
going, F\#'s pattern matching and set of built-in functions give you
this for free.  
  
We can fold over the event stream, starting with an empty list, to
append each item that was consumed, excluding the ones that were removed
later. Those projected items can then be grouped by category, to be
mapped into a category type that contains a sorted list of items.  
  
```fsharp
let handle read query =
        match query with
        | Query.List ->
            (
                let folder state e =
                    match e with
                    | Event.Consumed data ->
                        {
                            Id = data.Id;
                            Timestamp = data.Timestamp;
                            Category = data.Category;
                            Description = data.Description;
                            Url = data.Url
                        } :: state
                    | Event.Removed data ->
                        List.filter (fun x -> x.Id <> data.Id) state

                match read "$all"  with
                | EventStream.NotExists _ -> { Categories = Seq.empty }
                | EventStream.Exists ( _ , events ) ->
                    (
                        let items = Seq.fold folder [] events
                        let categories =
                            items
                            |> Seq.groupBy (fun x -> x.Category)
                            |> Seq.map (fun ( x , y ) -> { Name = x; Items = y |> Seq.sortBy (fun x -> x.Timestamp) })
                        { Categories = categories }
                    )
            )
```

The result can be printed to the console using a more imperative
style.

```fsharp
match parse argv with
| Success(Query(query)) ->
   (
       let result = QueryHandling.handle (read path) query

       for c in result.Categories do
           printfn "%s" c.Name
           printfn "%s" (String.replicate c.Name.Length "-")
           for i in c.Items do
               let ts = i.Timestamp.ToString("dd/MM/yyyy")
               printfn "%s - %s | %s (%s)" ts i.Id i.Description i.Url
   )
| _ -> ...
```

And that's it, we've come full circle. We can now consume items, remove
items and query for a list of consumed items.  

```
λ Consumed.exe -help

Following commands are available:
-n consume -c category -d description -u url
-n remove -id id
-n list

λ Consumed.exe -n consume -c book -d "The Drawing of the Three" -u "..."

Yay! Something happened = Success ...

λ consumed.exe -n list

book
----
24/05/2015 - 24052015125831 | The Drawing of the Three (...)
``` 

Compared to the node.js implementation, the F\# version required
substantially less code (two to three times less). More importantly,
although I wrote tests for both, I felt way more confident completing
the F\# version. A strong type system, discriminated unions, pattern
matching, purity, composability and a smart compiler makes way for
sensible and predictable code.  
  
Source code is [up on Github](https://github.com/JefClaes/consumed-f).
