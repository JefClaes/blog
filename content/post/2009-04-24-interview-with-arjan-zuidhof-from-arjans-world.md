+++
title = "Interview with Arjan Zuidhof from Arjan's World"
slug = "2009-04-24-interview-with-arjan-zuidhof-from-arjans-world"
published = 2009-04-24T16:39:00.005000+02:00
author = "Jef Claes"
tags = [ "Interview",]
+++
Like the title says, I had a little chat with Arjan Zuidhof from Arjan's
World.  
  
Arjan has a opinionated linkblog, on which he posts on a daily basis.  
  
Here it goes..  
  
<span style="font-weight: bold;">Next to blogging, what do you do for a
living?</span>  
<span style="font-weight: bold;">  
</span>I'm a thirty-something developer from the Netherlands working as
an inhouse .NET developer in a big company, somewhere in the Randstad
(western part of the country). I mainly work on projects related to
customer data in the broadest sense. We pull all kinds of tricks to
relate several pieces of data like names and addresses and do judgments
on them based on complex business rules. Sounds dull, but it can be
quite interesting. I'm looking to see if I can pick up some more ASP.NET
work though, as web development is actually my secret love. So that's
why in my spare time I pick up things like ASP.NET MVC.  
  
<span style="font-weight: bold;">Can you give an example of a project
you are working on? What is the structure, which Microsoft technologies
do you use? </span>  
  
Right now I'm working on a fairly large project that's in maintenance.
It's a bunch of spaghetti code on which some new functionality must be
added. Difficult work, but I use unit tests, refactoring, and basically
the pragmatic principle of 'do not touch what does not absolutely need
to change'. It's hard though to find enough time to do all this AND add
additional features on customer request. But we all know that don't we?
The project was originally written in .NET 2.0, using basic NET remoting
to connect a Windows Forms client with a backend server. Unfortunately
the project needs to be supported for a couple more years, and does not
lend itself for improvement (WCF and WF come to mind here, but alas).
The good thing is we work with the latest Visual Studio / TFS stack, so
there's enough new stuff to explore.  
  
<span style="font-weight: bold;">It must be challenging to work on
legacy code. Are there any good books you've read on working with legacy
code? Are there some more tips you want to share?</span>  
  
I'm currently using the well known 'Working effectively with Legacy
Code' by [Michael Feathers](http://www.michaelfeathers.com/). It's a
biggie chock full of tips on how to get your teeth in spaghetti code and
make something nice out of it. Refactoring, introducing patterns where
appropriate, isolating parts of your code. It is all there. I would
advice not to read it from beginning to end, but rather just dive in and
read the topics that you currently need to know about. Think Michael
advises this himself somewhere too.  
  
<span style="font-weight: bold;">What framework do you use for your unit
tests?</span>  
<span style="font-weight: bold;">  
</span>Arjan: We're using the default one in Visual Studio (don't they
call it Team Test?), but I'm investigating
[nUnit](http://www.nunit.org/index.php), which is way nicer and more
powerful.  
  
<span style="font-weight: bold;">Our team is using Team Foundation as
well. We are currently not making use of its full potential though. We
mainly use it for Source Control. Which features of TFS do you use?
Which ones do you like, which ones do you hate and which ones haven't
you tried out yet but look very interesting.</span>  
<span style="font-weight: bold;">  
</span>We mainly use the developer related features, since (project)
managers are a bit hesitant here to put the system into good use :) That
means work item / feature / bug tracking, builtin version control (which
sometimes needs to be screamed at to work correctly, by the way). We're
using several build definitions that deploy automatically to drop zones.
That's about it I guess. There's the nice reports and all, I know, but
the developers don't really need them currently to get the job done.  
  
<span style="font-weight: bold;">Let's change the conversation a bit
onto your blog. I think you are doing a great job, but how do you manage
all that information?</span>  
<span style="font-weight: bold;">  
</span>A decent feedreader of course :) At first I used Bloglines, but
some time ago it had a lot of glitches and outages. It was constantly
'forgetting' your status. Then I found everyone and their mother talking
about Google Reader. Of course that's the most used feed reader
nowadays. And with good reason!  
  
<span style="font-weight: bold;">To get an idea. Can you tell us how
many blogs you follow? And how many posts you read on average each
day?</span>  
<span style="font-weight: bold;">  
</span>I'm using the Reader to successfully track something slightly
less than 600 feeds on a daily basis. Don't know how I manage, I just do
:) Well, as a matter of fact, I do know: it's all about creating the
right categories: most important feeds are always checked completely.
But there's a lot of fluff, of just basic news out there which I only
read when I have the time (not often), and categories that I just
quickly skim for interesting topics.  
  
How many posts a day: that's the nice thing about Google Reader, it
tracks this for you in a 'Trends' section. Trends says I 'read' 5217
article in the past 30 days. Now, this doesn't mean that I completely
read them all (mind you), just that they were in front of my eyes for a
moment, to see if they were interesting enough to link to. I guess I
make this decision in a split second, based on title of the post, and
the name of the author.  
  
<span style="font-weight: bold;">Have you tried out non-webbased RSS
Readers?</span>  
<span style="font-weight: bold;">  
</span>Not really. Tried FeedDemon and RSSBandit some time ago. But
working on several machines requires keeping track of several software
installs and use something like Dropbox to synchronise the data files.
Could easily do that, but since I'm rather the lazy type - there's your
real reason I prefer web based readers - haven't done that so far. And
Google Reader's good responsiveness is keeping me from switching.  
  
<span style="font-weight: bold;">Do you feel like reading blogs helps
you a lot in being a better developer? If so, in which ways?</span>  
<span style="font-weight: bold;">  
</span>Well, sure. For the obvious reasons: teaching me new and often
better ways to do something (let's call this the 'tricks'). Then there's
another slot of bloggers who focus more on the deeper insights behind
programming (design pattern, methodology, agile development etc.). You
don't always need to agree completely, but there is lots of good content
out there that at least deserves some serious mulling over. And
sometimes they show me how \*not\* to do things. Fortunately the first
category is way bigger than the second (You probably all know [The Daily
WTF](http://thedailywtf.com/). If not, then you absolutely pay them a
visit for an overwhelming number of examples of the latter category).  
  
<span style="font-weight: bold;">To wrap up this interview (A Top-10?).
Which are your favorite blogs? </span>  
  
A Top-10 you ask? Don't like top-x lists at all, but since unscientific
evidence has shown that they have a great click-through rate, we have to
deal with them :) Only thing: there is not one single blog that I would
call upon being my no 1. Besides, it's hard as by definition this would
exclude an overwhelming amount of top notch blogs. Still, away with the
excuses,here's the unsorted list:  
  

1.  The guys at [Codebetter.com](http://codebetter.com/). Almost every
    day they contribute some food for thought related in one way or the
    other to methodology. Highly reccomended!
2.  [Los Techies guys](http://www.lostechies.com/): same reason as
    above.
3.  [Leon at the Secret Geek blog](http://secretgeek.net/). Humorous and
    less humorous posts on a not so regular basis. He brought my little
    link blog fame by awarding me the ‘Next Mike Gunderloy’ award when
    Mike Gunderloy stopped linkblogging when 2007 came to an end.
4.  [Simone Chiaretta a.k.a. the Code
    Climber](http://codeclimber.net.nz/). Enthusiastic Italian MVP who
    just released a book on ASP.NET MVC.
5.  [Scott Hanselman](http://www.hanselman.com/blog/). Though he lost a
    little bit of his touch since joining the ranks at Microsoft, he’s
    absolutely an avid blogger, podcaster and overall tool geek.
6.  [The Lifehacker.com blog](http://lifehacker.com/). For a couple
    years already lifehacks, GTD, and more recently the rise of social
    software attract me. There is truly a revolution taking place in
    this field. A lot of things we took for granted for a long time are
    suddenly obsolete without us realising it. Let this entry in the
    list be representative of my interest in this domain.
7.  [Michael Lopp a.k.a. Rands](http://www.randsinrepose.com/) (in
    repose). The guy who wrote “Managing Humans”, great book. New
    articles drip in on his blog; not too often, but when they do, you
    do yourself a disfavor not to read them
8.  [Jeff Atwood](http://codinghorror.com/). Though he gets a lot of
    flak, the guy does an awful lot of research for high high profile,
    high rotation blog (100K+ readers). There is not a subject he has no
    opinion on
9.  Rajiv Popat: .NET developer writing a lot about tools, technology
    and project management. Think I said it before but the guy is a
    hidden gem.
10. All the other guys and gals that were not mentioned here but make
    great contributions to the blogosphere. Thanks for giving me enough
    stuff to link to!

  

<span style="font-weight: bold;">And thank you for the talk!</span>
