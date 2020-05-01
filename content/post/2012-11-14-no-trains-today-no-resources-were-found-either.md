+++
title = "No trains today? No resources were found either."
slug = "2012-11-14-no-trains-today-no-resources-were-found-either"
published = 2012-11-14T12:26:00+01:00
author = "Jef Claes"
tags = [ "Ramblings", "LOL",]
+++
Belgian's National Railway has decided to strike again today to assail
Europe's oncoming austerity. I don't think there is anything wrong with
sticking it to the man, or [fighting for your right to
party](http://www.youtube.com/watch?v=eBShN8qT4lk), if you believe it is
just, yet the preferred tactics don't feel quite right. There must be
more constructive ways to get your point across, instead of terribly
inconveniencing all those people who give you a job in the first place,
your customers. Any takers on proposing better alternatives?  
  
With [an average of 7 days of striking per
year](http://www.knack.be/nieuws/belgie/gemiddeld-7-wilde-spoorstakingen-per-jaar/article-4000207259915.htm),
it's self-evident that bashing our railway company has become a national
sport. I hardly ever participate, but today I'm happy to make an
exception. I have something tangible to show; a mini [The Daily
WTF](http://thedailywtf.com/). This weekend my girlfriend called me over
to her desk to show me this.  
  

[![](../images/thumbnails/2012-11-14-no-trains-today-no-resources-were-found-either-Afbeelding+3.png)](../images/2012-11-14-no-trains-today-no-resources-were-found-either-Afbeelding+3.png)

  
Taking it out on their IT department might not be completely fair, but I
couldn't resist. How do you succeed in putting your home page in
production like that? It wasn't even fixed for quite some time. You can
see by looking at the url and the source that they're using ASP.NET
WebForms, but they must be rolling their own technique for localization.
I can't imagine this passing through  acceptance without someone
noticing, so it has to be a deployment issue. Was the production build
only partially successful? Did those unfortunate few having to come in
on weekends for deployment forget to carry out a manual procedure? Did
someone bork the production configuration? Why did it take so long to
rectify this? Was the gap between the teams responsible for development
and deployment too wide? Was there no monitoring for these 'NOT\_FOUND'
errors? Are they even being treated as such? Did anyone even bother to
smoke test after deployment?  
  
Is there anyone else who wants to take a stab at guessing what went
wrong here?
