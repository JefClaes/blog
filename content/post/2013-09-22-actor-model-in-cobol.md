+++
title = "Actor Model in COBOL"
slug = "2013-09-22-actor-model-in-cobol"
published = 2013-09-22T16:38:00+02:00
author = "Jef Claes"
tags = [ "Architecture", "DDD", "Ramblings",]
+++
In an Actor system, each Actor acts as a self-contained and autonomous
component. An Actor can only communicate with other Actors by exchanging
messages - they are not allowed to share state. Messages are handled
asynchronously, and are nondeterministic. The location of Actors should
be transparent; they can either live on the same machine, or on a
distributed system. These properties make the Actor Model a great fit
for parallel and distributed computing.  
  
Even without considering parallelism and distribution, the Actor Model
appeals to me. If you take an existing system, and make each aggregate
in that system an Actor, what would the impact be? You can get rid of
all the messaging and queuing infrastructure; messages and asynchrony
are now first class citizens. Where you had to have discipline abiding
the aggregate rules of thumb - modifying one aggregate per transaction,
no references to other aggregates, Tell Don't Ask... - the very nature
of Actors will guide you into doing the right thing.  
Next to these implementation concerns, the model itself can be used as a
framework for modeling and reasoning about complex systems. Once they
are well educated on the constraints, it must come natural for domain
experts as well.  
  
Having worked with a team of mainframe programmers over the last year,
it recently came to me that how they have designed their systems over
the years is compatible with a good amount of Actor laws.  
  

[![](../images/thumbnails/2013-09-22-actor-model-in-cobol-ActorModelInCOBOL.JPG)](../images/2013-09-22-actor-model-in-cobol-ActorModelInCOBOL.JPG)

  
**Composition**  
**  
**A good thing about COBOL seems to be that it's nearly impossible to
write maintainable big programs, so you're forced to decompose your
program into smallish autonomous components - into jobs.  
  
**Messages**  
**  
**Communication between these jobs happens by passing flat files around
- the only format that's supported out-of-the-box.  
Messages come in, and new messages go out. Jobs will never mutate the
incoming payload, a new copy is created instead; pipes and filters.  
Folders serve as a queue, allowing files to be processed asynchronously
and nondeterministic.  
  
Staying clear of mutating messages makes debugging extremely easy;
you'll never hear someone on the team asking for reproduction steps,
they just restore the production archives locally.  
  
**Addresses**  
**  
**Actors send messages to other Actors using their addresses. This can
be a memory or disk address, a network address, email address, whatever
really. In mainframe land, file system paths serve as addresses.  
  
**No shared state**  
**  
**In general they stay away from jobs sharing state; the default is to
lock files exclusively, so sharing them is highly impractical. Even most
static data gets synchronized instead of shared - banking reference
data, customer addresses, configuration etc...  
  
**Scheduling**  
**  
**A scheduler sits on top of all these jobs. Its responsibility is to
start a job when a new file arrives. If a job fails, the scheduler acts
as a supervisor and will notify operations, which will investigate the
issue - probably look at what's on the file system, and use the same
scheduler to restart the failed job. Notice that one failing job doesn't
impact other jobs.  
  
All of this gives you an automated, highly observable and fault-tolerant
system.  
  
*Although COBOL remains to be a horrible language, mainframe systems do
have their strengths. There must be some good reason a lot of core
business functions are still running on mainframes, right? Maybe
similarities with the Actor Model are far-fetched and merely a figment
of my imagination. Feel free to share your thoughts. *
