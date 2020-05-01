+++
title = "When your commands spell CUD"
slug = "2013-08-04-when-your-commands-spell-cud"
published = 2013-08-04T19:08:00.001000+02:00
author = "Jef Claes"
tags = [ ".NET", "Architecture", "DDD", "Ramblings",]
+++
A good while ago, I blogged on commands (and queries). After exploring
various flavors, I eventually settled on this one; [commands, handlers
and an in-memory bus that serves as a command
executor](http://www.jefclaes.be/2013/01/separating-command-data-from-logic-and.html).  
  
Commands help you in supporting the ubiquitous language by explicitly
capturing user intent at the boundaries of your system - think use
cases. You can look at them as messages that are being sent to your
domain. In this regard, they also serve as a layer over your domain -
decoupling the inside from the outside, allowing you to gradually
introduce concepts on the inside, without breaking the outside. The
command executor gives you a nice pipeline you can take advantage of to
centralize security, performance metrics, logging, session management
and so on.  
  
We always need to be critical of abstractions though, and regularly
assess their value. A smell that might indicate that commands might not
be working for you, or are adding little value, is that the first
letters of your commands spell CUD - Create Update Delete.  
  
For example; CreateCarCommand, UpdateCarCommand and DeleteCarCommand.  
  
**The language needs attention**  
**  
**Possibly, your team hasn't fully grasped the power of cultivating the
ubiquitous language. If you start listening to your domain experts, you
might end up with totally different command names; TakeInNewCarCommand,
RepaintCarCommand, InstallOptionCommand and RemoveCarFromFleetCommand.  
  
Maybe though, there is no language at all, and you're really just doing
CRUD. If the context you are working on is implementing a generic or
supporting subdomain this might not be terrible.  
  
**If I'm doing CRUD, do I still need commands?**  
**  
**Commands help you decouple the inside from the outside. If there is no
domain on the inside though, they can still help you decouple the
application layer from other concerns. You might prefer to use another
facade to separate concerns though, such as a thin service layer. I
don't think the service layer abstraction gives you anything commands
don't though. Maybe you don't find any value in separating things at
all, and just dump everything in the the application layer.  
  
All of these approaches are valid. You just have to consider the
trade-offs. With these last approaches, next to losing decoupling in
from out, you also lose that central pipeline that a command executor
gives you.  
  
**Doesn't my application layer give me this pipeline for free?**  
**  
**It sure can. Looking at modern networking stacks, these all have
interception points built in. For example; NancyFx allows you to hook in
the request pipeline using before and after hooks; Web API gives your
message handlers and action filters; and WCF has a concept of
interceptors.  
  
Not all application frameworks do though - think of frameworks targeting
desktop software.  
  
The advantage of having your own pipeline, instead of solely having to
rely on your application framework's interception points, is that you're
boss and don't have to study the ins and outs of each framework, and
hope for the framework to have thought of your needs. Also when you need
to support multiple application layers, you don't have to implement all
features twice.  
  
**What about using aspects instead of a pipeline to centralize all these
concerns?**  
**  
**You can - instead of a pipeline - use aspects to take care of
croscutting concerns such as security, logging, session management.. and
have them woven into your executable at compile- or runtime. I think of
aspects as if they were macros, which save you on lines of code written,
but also often conceal the real problem; missing concepts. While they
try to sell you on separation of concerns, notice that you're actually
still producing procedural code, but instead of writing it by hand,
you're now letting an AOP framework do it for you. Add harder testing,
debugging and readability to the bunch, and you can understand why I'm
not a fan of AOP. There are scenarios where this all doesn't matter much
though, and to strengthen the cliche; granular logging is a good use
case.  
  
When your commands spell CUD, it might indicate you could do without
them. Do realize what the consequences are of taking them away though;  

-   you lose the opportunity to capture user intent at the boundaries of
    your system, to strengthen the ubiquitous language
-   you may need an alternative facade to decouple in from out
-   you lose that command executor serving as your own pipeline
