+++
title = "TDD as the crack cocaine of software"
slug = "2014-12-28-tdd-as-the-crack-cocaine-of-software"
published = 2014-12-28T17:29:00+01:00
author = "Jef Claes"
tags = [ "Ramblings",]
+++
> The psychologist Mihaly Csikszentmihalyi popularized the term "flow"
> to describe states of absorption in which attention is so narrowly
> focused on an activity that a sense of time fades, along with the
> troubles and concerns of day-to-day life. "Flow provides an escape
> from the chaos of the quotidian," he wrote. 

This is a snippet from the highly recommended book [Addiction by
Design](http://www.amazon.com/gp/product/0691160880/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0691160880&linkCode=as2&tag=diofanedebyje-20&linkId=B2LQH4574PP6A5AL),
which not only gives you an incredibly complete overview of the gambling
industry, but also insights into the human psyche which apply far
outside the domain of gambling.  
  
For me, this book was an eye-opener, with the biggest realization being
that most gamblers don't play to win. They play to lose. To lose
themselves. Slot machines and video poker are for many people the
quickest and surest way to reach flow. It's this phenomenon that has
earned machine gambling the title of "the crack cocaine of gambling."  
  
It's not just gamblers that crave for flow though, we all do.  
  
Some of us get up early on the weekends, to drive halfway across the
country for a few hours of intensive mountain biking. Others come home
after work, throw their laptop in the corner, to engage in an online
shooter, zoning out for a good hour. Others will accidentally waste
their entire Sunday morning solving a crossword puzzle they bumped on
reading the newspaper.  
  
All these activities meet a specific set of preconditions.  

> Csikszentmihalyi identified four preconditions of flow: first, each
> moment of the activity must have a little goal; second, the rules of
> attaining that goal must be clear; third, the activity must give
> immediate feedback so that one has certainty, from moment to moment,
> on where one stands; fourth, the tasks of the activity must be matched
> with operational skills, bestowing a sense of simultaneous control and
> challenge.

Machine play has all these properties. Let's look at video poker. The
goal is to make a winning combination. The set of winning combinations
should be easy enough to remember; they're similar to live poker. After
pushing "deal" you get five cards. The player decides which cards to
"hold". Pushing the "deal" button the second time will draw new cards
from the same virtual deck. After the draw, you immediately know whether
you've won or lost. Feedback is instantaneous. A game is over in a few
seconds. Although the outcome is determined by chance, there is some
degree of skill involved; it's up to you to hold the right cards.  
<span class="Apple-tab-span" style="white-space: pre;"> </span>  
As programmers we're lucky enough to inadvertently end up in the zone
frequently. Without a doubt, it's in this state most of us do our best
work. In the zone, it's constant feedback and a sense of moving forward
that keep me going. One could argue that the zone is inherent to the
activity of programming. I'd say that the length of the feedback loop
and the size of the goals are critical and hard to maintain without
working at it.  
  
In this regard, there are a few techniques that help me reach a state of
flow. At first I could get by just trying to get the code to compile or
to just launch whatever it was I was working on. But once you're
comfortable with a code base, getting it to compile isn't much of a
challenge, and having to start your application to get feedback gets old
real quick. Most often it's TDD that helps me get there these days. You
start of with a failing test, your mission: to make it pass. The rules
are simple; when your test goes from red to green, you're allowed to
move on. It's important that tests are fast to be able to give you that
immediate feedback. How fast? Fast enough for you not to lose focus. It
stands for itself that the fourth precondition is met too; you're
writing the code, doing your best to bend it your way.  
  
When TDD is sold as a productivity booster, it are often strengths such
as automated continuous validation of correctness, partitioning of work
in smaller units and cleaner and better designed code that are used as
arguments. While these are valid arguments, it's a shame that the power
of TDD as a consistent gateway to flow gets neglected or undersold.  
  
Getting in the zone by yourself is one thing, getting there surrounded
by a group of people is often out of the question. Here [Event
Storming](http://www.jefclaes.be/2014/05/ncrafts-eventstorming-slides.html)
has helped me out. Small goals; what happens before this event? Rules;
write the previous event down on a yellow post-it. Feedback; once the
post-it is up, we see that we're reaching a better understanding of the
big picture. Control and challenge; you're the one searching for deeper
insight, writing and putting up the post-its.  
  
The activities that get me in a state of flow are the ones that I enjoy
the most and which enable me to output my best results. If you reread
the four preconditions, and assess the things that get you going, you
might learn that the same goes for you.
