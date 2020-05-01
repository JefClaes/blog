+++
title = "A solar storm anecdote"
slug = "2012-02-01-a-solar-storm-anecdote"
published = 2012-02-01T08:43:00.001000+01:00
author = "Jef Claes"
tags = [ "Ramblings", "LOL",]
+++
Last week, several news channels reported on the strongest [solar
storm](http://en.wikipedia.org/wiki/Solar_flare) since 2005. [This news
item](http://www.bbc.co.uk/news/science-environment-16701407) reminded
me of a peculiar support ticket we received one gray Monday morning a
few years ago, when I was still writing software for fire departments.  

> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*  
> **Ticket 7238**  
> Subject: **AVL broken**  
> Status: New  
> Description  
> 06:22 Vehicles stay mostly stationary on the map, even when we are  
> positive they are en route.  
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

Fire departments that have to cover a large area - and are wealthy
enough - often use [AVL (Automatic Vehicle
Location)](http://en.wikipedia.org/wiki/Automatic_vehicle_location) to
track their vehicles and visualize them on a map. This is extremely
valuable, because you always want to dispatch the vehicles with the
smallest response time to a high priority intervention. Also being able
to advise drivers of possible blockages and toxic gas clouds can save
lives. To be able to track a vehicle, an AVL module is installed into
each vehicle's cockpit. This module uses GPS to determine the location
and sends the location data over GPRS to a central server.  
  
On our end, we had a third party service listening for those location
packets and translating them into a more understandable format. This
service, not being mission critical, wasn't being monitored, so we had
to look into the logs to see what was going on. Scrolling through
megabytes of debug logs, we couldn't find anything suspicious.  
  
While I was investigating this, a co-worker had come in and was reading
through his mails while sipping on his morning coffee. After reading
support ticket 7238, he nonchalantly said he knew what was going on with
AVL and he would take over from there.  

> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*  
> Ticket 7238  
> Subject: AVL broken  
> Status: Pending  
> Description  
> **08:45 I heard on the radio that there is a solar storm going on at  
> the moment, which affects sattelites. The AVL module might have  
> a hard time getting a GPS fix. This issue should solve itself over  
> time. We will keep an eye on this issue.**  
> ---------------------------------------------------------------------------------  
> 06:22 Vehicles stay mostly stationary on the map, even when we are  
> positive they are en route.  
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

A few days passed and although the solar storm was over, we were still
seeing signifcant packet loss. After spending a few hours working the
ticket, in which we restarted the service, monitored network traffic on
the machine and conctacted the telephony provider, we were getting a bit
desperate. We were discussing other potential paths to investigate, when
one of our more seasoned co-workers asked "You guys did try restarting
the server, right?".  
  
Good enough, after restarting the server, we were seeing no more packet
loss and the vehicles started moving on the map again.  
  
[![](../images/thumbnails/2012-02-01-a-solar-storm-anecdote-PokerFace.png)](../images/2012-02-01-a-solar-storm-anecdote-PokerFace.png)  

> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*  
> Ticket 7238  
> Subject: AVL broken  
> **Status: Resolved**  
> Description  
> **15:47 The solar storm must be over. The vehicle locations are  
> being updated in a timely fashion again.**  
> --------------------------------------------------------------------------------  
> 08:45 I heard on the radio that there is a solar storm going on at  
> the moment, which affects sattelites. The AVL module might have  
> a hard time getting a GPS fix. This issue should solve itself over  
> time. We will keep an eye on this issue.  
> --------------------------------------------------------------------------------  
> 06:22 Vehicles stay mostly stationary on the map, even when we are  
> positive they are en route.  
> \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*

Until today, we never talked about ticket 7238 again.
