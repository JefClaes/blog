+++
title = "My understanding of event sourcing"
slug = "2013-10-06-my-understanding-of-event-sourcing"
published = 2013-10-06T18:32:00+02:00
author = "Jef Claes"
tags = [ "Architecture", "DDD",]
+++
I've been studying event sourcing from a distance for little over a year
now; reading online material and going through some of the excellent OS
code. Unfortunately, there would be no value introducing it into my
current project - it would even be a terrible idea, so I decided to
satisfy my inquisitiveness by consolidating and sharing my understanding
of the concept.  
  
**Domain events**  
**  
**An event is something that happened in the past.  
  
Events are described as verbs in the past tense. For example; amount
withdrawn, amount deposited, maximum withdrawal amount exceeded. Listen
for them when talking to your domain experts; events are as much a part
of the ubiquitous language as commands, aggregates, value objects
etc...  
  
Once you've captured a few events, you will notice how these concepts
have always implicitly been there, but by making them explicit you
introduce a whole new set of power tools to work with.  
  
**Event sourcing**  
**  
**Having defined domain events one more time, we can now look at event
sourcing. By the name alone, it should be obvious events are going to
play the lead role.  
  
In traditional systems, we only persist the current state of an object.
In event sourced systems, we don't persist the current state of an
object, but the **sequence of events** that caused the object to be in
the current state.  
  
In traditional systems, every time a change happens, we retrieve the old
state, mutate it, and store the result as our current state. In this
example, only the last column would be persisted.  
  

<table>
<thead>
<tr class="header">
<th><strong>Old amount</strong></th>
<th><strong>Command</strong></th>
<th><strong>Current amount</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td></td>
<td>CreateAccount</td>
<td>$0</td>
</tr>
<tr class="even">
<td>$0</td>
<td>Deposit $2000</td>
<td>$2000</td>
</tr>
<tr class="odd">
<td>$2000</td>
<td>Withdraw $100</td>
<td>$1900</td>
</tr>
<tr class="even">
<td>$1900</td>
<td>Withdraw $500</td>
<td>$1400</td>
</tr>
<tr class="odd">
<td>$1400</td>
<td>Withdraw $2000</td>
<td>$1400</td>
</tr>
<tr class="even">
<td>$1400</td>
<td>Withdraw $300</td>
<td>$1100</td>
</tr>
</tbody>
</table>

  
In event sourced systems on the other hand, we store the changes that
happened - the second column, not the current state. To arrive at the
current state again, we take all these events - and replay them.  
  

<table>
<thead>
<tr class="header">
<th><strong>Command</strong></th>
<th><strong>Event</strong></th>
<th><strong>Current amount</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>CreateAccount</td>
<td>AccountCreated</td>
<td>$0</td>
</tr>
<tr class="even">
<td>Deposit $2000</td>
<td>Deposited $2000</td>
<td>$2000</td>
</tr>
<tr class="odd">
<td>Withdraw $100</td>
<td>Withdrawn $100</td>
<td>$1900</td>
</tr>
<tr class="even">
<td>Withdraw $500</td>
<td>Withdrawn $500</td>
<td>$1400</td>
</tr>
<tr class="odd">
<td>Withdraw $2000</td>
<td>Maximum withdrawal amount exceeded! </td>
<td>$1400</td>
</tr>
<tr class="even">
<td>Withdraw $300</td>
<td>Withdrawn $300</td>
<td>$1100</td>
</tr>
</tbody>
</table>

*  
*Notice how we already gain better insights into what's happening by
seeing an explicit *maximum amount exceeded* event.  
*  
Next time; what does this look like in code?*  
*  
Feel free to complement and correct my understanding of event sourcing.*
