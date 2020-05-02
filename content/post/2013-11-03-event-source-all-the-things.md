+++
title = "Event source all the things?"
slug = "2013-11-03-event-source-all-the-things"
published = 2013-11-03T18:45:00.001000+01:00
author = "Jef Claes"
tags = [ "opinion",]
url = "2013/11/event-source-all-things.html"
+++
Having covered
[projections](http://www.jefclaes.be/2013/10/event-projections.html)
last week, I think I have come full circle in these posts that turned
out to be a small preliminary series on event sourcing. Even though
there are still a vast amount of nuances to discover, I think I've
captured the gist of it. Even without running an event sourced system in
production - I feel as if I somewhat have an idea of what event sourcing
can bring to the table.  
  
Event sourcing gives you a complete history of events that caused an
aggregate to be in its current state. In some scenarios this will add an
enormous amount of value, in other scenarios it will give you nothing -
it might even steal time and effort.  
  
The first thing you do - before even considering implementing event
sourcing - is talking to your business. Do they feel as if events are a
natural way to represent what's going on in their domain? Event sourcing
is a lot more than just a technical implementation detail, discovering
and understanding all of what goes on in a domain is a big investment -
from both sides. Is it worth the trouble?  
  
In my first job I worked on software for fire departments. I just now
realize in how many bits of our solution event sourcing could have
helped us:  
- the life cycle of a vehicle assigned to an emergency: vehicle dispatched, vehicle left the station, vehicle en route, vehicle arrived on the scene, vehicle back in the station...
- a person's career: person was promoted, person was detached to another station, person learned a new skill...
- a shift's schedule: person attached to unit, person returned to person pool, unit dispatched...

This data had to be made available in a set of diverse read models.
Getting the data out was complex at times, often even impossible. A lot
of these changes had to be propagated to external systems; there was no
way to get that info out in real-time, and external systems had no
notion of *what* happened.  
  
In one of the functionalities of a system I'm currently working on,
users also wanted to know what happened in the past, but for completely
different reasons. Being in a financial context, they wanted to know who
was responsible for changing system settings. Here it's not an event log
they need, but a simple audit trail.  
  
If it is just a passive log your business wants, you can get away with
cheaper alternatives; a command journal, an audit trail and so on.  
  
### Benefits
 
Event sourcing goes hand-in-hand with Domain Driven Design. Events are
a great tool to go from a structural model to a behavioural model,
helping you to capture the true essence of a domain model.  
  
Building and maintaining an event store should be doable. It's an
append-only data model, storing serialized DTO's with some meta data.
This makes - compared to ORM's and relational databases - tooling easier
as well.  
  
In traditional systems, you have to keep a lot of things in your head at
once; how do I write my data, but also how do I query my data, and more
importantly how do I get my data out in all these different use cases
without making things too hard. In event sourced systems, separating
writes from reads makes for more granular bits, easing the cognitive
load.  
  
Events can be projected into anything: a relational database, a document
store, memory, files... This allows you to build a read model for each
separate use case, while also giving you a lot of freedom in how you're
going to persist them.  
  
You can replay projections, rebuilding a read model from scratch. Forget
about difficult data migrations.  
  
Testing feels consistent and very complete. A test will assert if all
the expected events were raised, but will also implicitly assert that
unexpected events were *not* raised. Testing projections is also
straight-forward.  
  
Events provide a natural way of integrating with other systems.
Committed events can be published to external subscribers.  
  
Troubleshooting becomes easier since a developer can copy an event
stream from production, and replay it locally - reproducing the exact
issue without jumping through hoops getting the system in a specific
state.  
  
Instead of patching corrupted production data directly, you can send a
compensating event or fix the projection and replay everything. This way
nothing gets lost, and consistency between code and outcome is
guaranteed.  
  
### Downsides  
  
Defining events is hard. Defining good events takes a lot of practice
and insight. If you're forcing a structural model into a behavioural
one, it might even be impossible. So don't even consider turning CRUD
into an event sourced model.  
  
There are a few places you need to be on the look out for performance
bottlenecks. Event streams of long lived aggregates might grow very big.
Loading a giant event stream from a data store might take a while -
snapshots can help here. Projecting giant event streams might get you
into trouble too - how long will it take to rebuild your read model,
will it even fit into memory? Making projections immediate consistent
might become a problem if you do a lot of them. Parallelization or
giving up on immediate consistency might bring solace.  
  
Events don't change, versioning might get awkward. Are you going to
create a new event type for each change, or will you relax
deserialization? Or maybe you want to implement event migrations?  
  
Since you're persisting multiple models; events and one or more read
models, you're going to consume more storage, which will cost you.  
  
### Adaptation in the wild  
  
Although there are - from a a business and engineering perspective -
some good arguments to be made for event sourcing, those arguments only
apply to a modest percentage of projects. Even when there's a strong
case to be made for event sourcing, there are very few people with
actual experience implementing an event sourced system and prescriptive
frameworks that you can just drop into a project and feel good about,
are lacking. Most won't even care about event sourcing to start with,
but even if they do, it's a fight upstream; it introduces a risk most
might not be comfortable with.  
  
Having said that, there are some really good projects out there that are
steadily gaining popularity and maturity. Pioneers in the field are
sharing and documenting their experiences, lowering the barriers for
others. Things are moving for sure.  
  
As always, event sourcing is not a paradigm to blindly apply to each and
every scenario, but definitely one worth considering.  
  
*Since I'm not running any of it in production, tell me what I'm
missing, there must be more things that turn out to be harder than they
sound at first right? If you're not running it in production, but
thinking about it, what are some of your concerns? What are your
predictions for the future of event sourcing?*
