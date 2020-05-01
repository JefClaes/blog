+++
title = "My Christmas holiday project postmortem"
slug = "2013-02-24-my-christmas-holiday-project-postmortem"
published = 2013-02-24T16:42:00.001000+01:00
author = "Jef Claes"
tags = [ "Ramblings",]
+++
Somewhere over a year and a half ago I discovered the music of Dire
Straits, which has sparked a fanatical love and fascination for the
guitar in me, and basically for every piece of music [Mark
Knopfler](http://www.markknopfler.com/) has ever touched (\*). A year
ago, I finally had the courage to pick up the guitar myself. Not sure if
I'd stick with it, I made an uninformed purchase of a rather inexpensive
Squier Jazzmaster, just because it somewhat resembled the real object of
desire, a [Fender
Stratocaster](http://en.wikipedia.org/wiki/Fender_Stratocaster). Three
months ago, I got rid of the Jazzmaster, and bought myself a tango red
Mexican Stratocaster, and I'm in love with it. Yet, I have also become
very fond of the sound of a [Les
Paul](http://en.wikipedia.org/wiki/Gibson_Les_Paul) these days. Having
just bought the Strat, I thought I could maybe find a cheap used Les
Paul online.  
  
I set out to find one on [the most popular Belgian online secondhand
marketplace<span id="goog_2007999932"></span>](http://www.2dehands.be/)
(600k visitors daily), so I started browsing their listings daily. This
turned out to be rather cumbersome and inefficient: constantly repeating
the same process, items were already sold before I could make a bid,
there were no new items since the last time I visited... It didn't take
me long before I started thinking of a way to automate this dull
process. Looking at other marketplaces, I found that some unburden their
users by providing notifications; push instead of pull. Maybe I could
build something similar?  
  
Doing a bit of research over the weekend, I found out that they expose,
what I call, an *accidental* API; written in first place to provide a
snappy mobile user experience, not to expose all their data to third
parties. Having an uncomplicated way of searching their data, I built a
bit of code on top of it. Nothing all too fancy though; a [Quartz
job](http://quartznet.sourceforge.net/) which periodically queries their
service, parses the results and stores them in a
[RavenDB](http://ravendb.net/) database. A few times a day, these search
results are then compiled, and sent to my inbox using
[MailGun](http://www.mailgun.com/). All of this running for free on
[AppHarbor](https://appharbor.com/).  
  
Showing all of this to the girlfriend, she asked if I could set up the
same thing for her, but then for a specific type of camera. This is when
I decided it could be useful enough to make it publicly available. I
thought of a few ways to support the costs of hosting (which are
extremely low): embed ridiculously relevant ads in the mails, make
people pay for more frequent polling, or sell it (although very
unlikely).  
  
Two weeks later, I had something working online.  
  

[![](/post/images/thumbnails/2013-02-24-my-christmas-holiday-project-postmortem-tweedehandsmeldingen.PNG)](/post/images/2013-02-24-my-christmas-holiday-project-postmortem-tweedehandsmeldingen.PNG)

  
But how do I inform people of its existence? I first thought of using
Twitter to monitor for relevant tweets where people ask for something
secondhand. I started out by using a new dedicated generic account, but
this got suspended rather quickly. In the second iteration, I used my
personal account. This yielded better results; people saw I was human,
and regularly thanked me for the tip. They didn't sign up too often
though..  
  
Not willing to give up on the idea already, I used Google Adwords to
advertise on the online marketplace directly. The results of this
campaign were sobering, but extremely valuable; people just didn't care.
As a side note; secondhand seems to be quite an expensive keyword!  
  

[![](/post/images/thumbnails/2013-02-24-my-christmas-holiday-project-postmortem-meldingenblog.PNG)](/post/images/2013-02-24-my-christmas-holiday-project-postmortem-meldingenblog.PNG)

  

[![](/post/images/thumbnails/2013-02-24-my-christmas-holiday-project-postmortem-adwords_results.PNG)](/post/images/2013-02-24-my-christmas-holiday-project-postmortem-adwords_results.PNG)

  
In hindsight, I can think of plenty of reasons why this somewhat useful
project has no success:  

-   The problem it is trying to solve obviously isn't enough of a pain!
-   People don't Google for it, and even if they did, this site had
    hardly any chance in making it to the first page.
-   In general the secondhand offering is enormous, and people often
    quickly settle for less.
-   Specialized markets aren't situated on these sites. 
-   People don't like giving away their email address, definitely not to
    strangers they don't trust. 
-   Everyone struggles to keep their inboxes clean, receiving mail puts
    off people.

  
Damn, it's always evident in hindsight.

  

Here are a few things I learned/got confirmed:

-   Being your own customer is priceless; you know exactly where the
    value is at.
-   Chances are you will never see a user; don't spend too much time
    optimizing for scalability and reliability.
-   Some Google ads plus a website with a simple form can be enough to
    let you cheaply validate the worthiness of pursuing an idea.

  
(\*) Take some time to explore his work: [brothers in
arms](http://www.youtube.com/watch?v=5vUDmFjWgVo), [postcards from
Paraguay](http://www.youtube.com/watch?v=aXXemzIo1ao), [song for Sonny
Liston](http://www.youtube.com/watch?v=VyOW8lQOG8Q), [you and your
friend](http://www.youtube.com/watch?v=-0T-JVeYXxs), and so many more
are worth a listen.
