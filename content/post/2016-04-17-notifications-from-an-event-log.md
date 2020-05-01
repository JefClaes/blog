+++
title = "Notifications from an event log"
slug = "2016-04-17-notifications-from-an-event-log"
published = 2016-04-17T17:37:00+02:00
author = "Jef Claes"
tags = [ "DDD", "F#",]
+++
User notifications are a feature that came as an afterthought, but
turned out to be rather easy to implement - without touching (read:
breaking) existing functionality - thanks to having an immutable event
log.  
  
In the domain I'm working in at the moment, we will often give users
incentives to return to the website, or to extend their stay on the
website. These incentives were only communicated by email at first, and
this is a decent medium when you want users to return to the website.
However, when you want to extend their stay on the website, you want to
avoid users switching contexts between your website and their mail
client. But also, as soon as they return to your website, you want to
show them a crisp overview of all relevant calls to action. Having most
calls to action map to a specific page, the list of notifications can
serve as a one-click starting point, lowering the hurdle to browse to a
relevant page.  
  
Notifying a user is one thing. Another use case we wanted to solve, is
to dismiss notifications as soon as they are no longer relevant.  
  
Two examples of when a notification might no longer be considered
relevant:  

1.  When a bonus is awarded to a user, he might ignore the notification
    and activate the bonus by directly browsing to the specific page.
2.  When a bonus is awarded to a user, he might not visit the website
    before the bonus expires.

In these cases, to avoid confusion and unsatisfied customers, we want to
dismiss the notification automatically.

  

Let's say that we're going to implement notifications for bonuses. We
have these type of events to work with.

  

On the other hand, we have a set of commands that interact with
notifications.

  

A notification has an identifier, references a user, contains some data,
and most importantly can be linked to *something*.  
  
Working from an immutable event log, we can project the events to
commands (to dispatch them eventually).  
  

When a bonus is awarded to a user, we will notify the user, providing
the template id and data that can be used inside of the template. In
this example, the notification can be linked to a specific bonus,
leveraging the bonus identifier.  
  
The user might now see something like this.  
  

[![](/post/images/thumbnails/2016-04-17-notifications-from-an-event-log-Notification1.PNG)](/post/images/2016-04-17-notifications-from-an-event-log-Notification1.PNG)

  
Being aware of the events which a bonus produces over its lifetime, and
their significance, we choose to dismiss the notification as soon as the
bonus is activated or expired (leveraging the bonus identifier as the
link again).  
  

[![](/post/images/thumbnails/2016-04-17-notifications-from-an-event-log-Notification2.PNG)](/post/images/2016-04-17-notifications-from-an-event-log-Notification2.PNG)

  
Now it's up to the UX team (if you're lucky enough to have one) to
decide on how to visualize the difference between a read and a dismissed
notification (if at all).
