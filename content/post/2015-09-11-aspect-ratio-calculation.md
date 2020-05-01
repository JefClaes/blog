+++
title = "Aspect ratio calculation"
slug = "2015-09-11-aspect-ratio-calculation"
published = 2015-09-11T23:40:00+02:00
author = "Jef Claes"
tags = [ "code"]
url = "2015/09/aspect-ratio-calculation.html"
+++
Earlier today I was writing a migration script in F\# where I had to
calculate the aspect ratio based on the given screen dimensions. This is
one of those problems where I don't even mind breaking my head over, but
directly head over to Stackoverflow to find an accepted answer which I
can just copy paste. Since I didn't find an F\# snippet I could use, I
ported some JavaScript, and embedded the result below for future snippet
hunters.  
  
The aspectRatio function does two things: 
1. Recursively find the greatest common divisor between the width and height 
2. Divide the width and height by the greatest common divisor

```fsharp
let aspectRatio width height =
  let rec greatestCommonDivisor x y =
    match y with 
    | 0 -> x
    | _ -> greatestCommonDivisor y (x % y)

  let gcd = greatestCommonDivisor width height

  width / gcd, height / gcd
  
// > aspectRatio 1200 900;;
// val it : int * int = (4, 3)
// > aspectRatio 100 100;;
// val it : int * int = (1, 1)
// > aspectRatio 900 1200;;
// val it : int * int = (3, 4)
```