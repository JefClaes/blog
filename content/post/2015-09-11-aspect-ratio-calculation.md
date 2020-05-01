+++
title = "Aspect ratio calculation"
slug = "2015-09-11-aspect-ratio-calculation"
published = 2015-09-11T23:40:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "F#",]
+++
Earlier today I was writing a migration script in F\# where I had to
calculate the aspect ratio based on the given screen dimensions. This is
one of those problems where I don't even mind breaking my head over, but
directly head over to Stackoverflow to find an accepted answer which I
can just copy paste. Since I didn't find an F\# snippet I could use, I
ported some JavaScript, and embedded the result below for future snippet
hunters.  
  
The aspectRatio function does two things: 1. Recursively find the
greatest common divisor between the width and height 2. Divide the width
and height by the greatest common divisor
