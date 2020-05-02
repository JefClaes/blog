+++
title = "My understanding of event sourcing"
slug = "2013-10-06-my-understanding-of-event-sourcing"
published = 2013-10-06T18:32:00+02:00
author = "Jef Claes"
tags = [ "ddd", "opinion"]
url = "2013/10/my-understanding-of-event-sourcing.html"
+++
I've been studying event sourcing from a distance for little over a year
now; reading online material and going through some of the excellent OS
code. Unfortunately, there would be no value introducing it into my
current project - it would even be a terrible idea, so I decided to
satisfy my inquisitiveness by consolidating and sharing my understanding
of the concept.  
  
### Domain events
  
An event is something that happened in the past.  
  
Events are described as verbs in the past tense. For example; amount
withdrawn, amount deposited, maximum withdrawal amount exceeded. Listen
for them when talking to your domain experts; events are as much a part
of the ubiquitous language as commands, aggregates, value objects
etc...  
  
Once you've captured a few events, you will notice how these concepts
have always implicitly been there, but by making them explicit you
introduce a whole new set of power tools to work with.  
  
### Event sourcing  
  
Having defined domain events one more time, we can now look at event
sourcing. By the name alone, it should be obvious events are going to
play the lead role.  
  
In traditional systems, we only persist the current state of an object.
In event sourced systems, we don't persist the current state of an
object, but the **sequence of events** that caused the object to be in
the current state.  
  
In traditional systems, every time a change happens, we retrieve the old
state, mutate it, and store the result as our current state. In this
example, only the last column would be persisted.  
  
```
Old amount      Command         Current amount
                CreateAccount   $0
$0	            Deposit $2000	$2000
$2000	        Withdraw $100	$1900
$1900	        Withdraw $500	$1400
$1400	        Withdraw $2000	$1400
$1400	        Withdraw $300	$1100
```

In event sourced systems on the other hand, we store the changes that
happened - the second column, not the current state. To arrive at the
current state again, we take all these events - and replay them.  
  
```
Command	        Event	                                Current amount
CreateAccount	AccountCreated	                        $0
Deposit $2000	Deposited $2000	                        $2000
Withdraw $100	Withdrawn $100	                        $1900
Withdraw $500	Withdrawn $500	                        $1400
Withdraw $2000	Maximum withdrawal amount exceeded! 	$1400
Withdraw $300	Withdrawn $300	                        $1100
```
  
Notice how we already gain better insights into what's happening by
seeing an explicit *maximum amount exceeded* event.  
  
*Next time; what does this look like in code?*