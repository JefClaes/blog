+++
title = "Spinning the wheel: clustering and near misses"
slug = "2014-12-14-spinning-the-wheel-clustering-and-near-misses"
published = 2014-12-14T17:13:00+01:00
author = "Jef Claes"
tags = [ "code", "ddd"]
url = "2014/12/spinning-wheel-clustering-and-near.html"
+++
The previous post showed a simple model casinos use to manipulate the
odds. Instead of relying on the physical wheel for randomness, they rely
on a virtual list of indexes that maps to the physical wheel.  
  
Using that same model, it's easy to fiddle with the virtual indexes so
that they map to misses right next to the winning pocket, creating "near
misses". "Near misses" make players feel less like losing, since you
"almost won". Casinos use this technique to get the next spin out of
you.  
  
Let's create more specific labels - a label for each individual
pocket. 

```fsharp
type WheelSpaceLabel =
    | Miss1
    | Miss2
    | Miss3
    | Win
```

The winning pocket is in the physical wheel at index two. We need the
virtual indexes to make clusters next to the winning label. Four indexes
map to Miss2, one maps to Win and three map to Miss3. We intentionally
ignore Miss1.  
  

[![](/post/images/thumbnails/2014-12-14-spinning-the-wheel-clustering-and-near-misses-SpinningTheWheelClusteringAndNearMisses.png)](/post/images/2014-12-14-spinning-the-wheel-clustering-and-near-misses-SpinningTheWheelClusteringAndNearMisses.png)

```fsharp
let physicalWheel = [Miss1; Miss2; Win; Miss3] |> Seq.ofList
let virtualWheel = [1; 1; 1; 1; 2; 3; 3; 3] |> Seq.ofList
```

Spinning the wheel one million times reveals the pattern; Miss1 gets
ignored, while we hardly ever win but very often "just" miss.  
  
```fsharp
Results seq [(Miss3, 37501); (Miss2, 49901); (Win, 12598)]
```

Since the law states that randomness and visualization are two separate
concepts, casinos are free to operate in this gray zone, as long as
randomness stays untouched.
