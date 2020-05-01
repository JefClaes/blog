+++
title = "Viewmodel assemblers in ASP.NET MVC"
slug = "2011-10-12-viewmodel-assemblers-in-asp-net-mvc"
published = 2011-10-12T20:14:00+02:00
author = "Jef Claes"
tags = [ "ASP.NET",]
+++
Working on a new ASP.NET MVC side-project, I have the luxury to
experiment with new technologies, but also with different patterns and
naming conventions.  
  
Something which bugged me in a previous project was that we made our
service layer return viewmodels. It worked rather well because the
service layer in our MVC project was just another layer between the real
domain services - where most of its work was creating viewmodels from
domain objects or translating viewmodels into domain objects, so they
could be passed to the domain services. Although it somehow worked
rather well, it felt dirty. Mostly because the name service is so
overloaded and overused, that it's often not clear what its
responsibility is.  
  
Searching for a more meaningful name, I thought of an assembler. A
simple object which fetches some domain objects and assembles them into
a clean viewmodel. I also consider making the assemblers work one-way,
from domain objects to viewmodels. Wrapping communication in the other
direction feels like overhead, bringing no added value. I'm comfortable
making the controller responsible for taking a piece of my composite
viewmodel and passing it to the domain services, avoiding layers of
unnecessary abstraction where possible.  
  
I tried representing this into a nice PowerPoint drawing.  
  

[![](../images/thumbnails/2011-10-12-viewmodel-assemblers-in-asp-net-mvc-ViewModelAssemblers.PNG)](../images/2011-10-12-viewmodel-assemblers-in-asp-net-mvc-ViewModelAssemblers.PNG)

  
Something for me to find out in the coming days, is how
[AutoMapper](http://automapper.org/) can facilitate me in assembling
these viewmodels.  
  
Anyway, as always, I appreciate your feedback. How do you handle these
scenarios? I'm also interested in hearing what naming conventions work
for you.
