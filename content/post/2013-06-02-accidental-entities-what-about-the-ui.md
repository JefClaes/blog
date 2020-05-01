+++
title = "Accidental entities - what about the UI?"
slug = "2013-06-02-accidental-entities-what-about-the-ui"
published = 2013-06-02T16:24:00+02:00
author = "Jef Claes"
tags = [ "Architecture", "DDD", "Ramblings",]
+++
This post is a follow-up to my previous blog post "[Accidental entities
- you don't need that
identity](http://www.jefclaes.be/2013/05/accidental-entities-you-dont-need-that.html)".  
  
In that post, we followed a consultant building an application for a car
rental. One of the requirements was that the CEO could manage a
collection of available colors. Although the tools at our disposal - a
relational database and NHibernate - wanted to trick us into making a
car reference one of these available colors by its identifier, we found
out that the CEO really thinks of a car's color as a value, and does not
care about a color's identity. This means that we didn't make a car
reference an available color, but we copied its value instead. This
allows the CEO to remove available colors, without it having an impact
on cars that already came in that color.  
  
The solution we're building contains a public facing web application
that allows customers to make reservations online, and a backoffice web
application - hosted on the intranet, that employees will use to manage
the cars.  
  
When a new car arrives at the car rental, a backoffice user will
register it. Once the car is registered - and in use, backoffice users
should still be able to change some of its characteristics; brand,
model, color, engine size, etc...  
  
Instinct tells us to add a page that enables editing all the car's
properties. Some of these properties are free text, some radio buttons,
but for the car color, it's a dropdownlist.  
Halfway through implementing this new functionality, we notice that
changing the color gets us into trouble. We populate the dropdownlist
with all available colors, but when we want to bind the car's current
color as the selected value, it's not in the list of available colors.
The CEO has removed the car's current color out of the list of available
colors.  
After a bit of tinkering, we come up with a workaround that adds the
car's current color to the available colors with a default value of -1.
This allows us to determine if the color needs to be changed.  
  

[![](/post/images/thumbnails/2013-06-02-accidental-entities-what-about-the-ui-EditCar.PNG)](/post/images/2013-06-02-accidental-entities-what-about-the-ui-EditCar.PNG)

  
Relational databases, RAD tools, scaffolding and anemic models have
poisoned our minds, making us throw up the database schema all over the
UI. We can do a lot more though.  
If we take a step back, and make an effort to discover what changing
these properties really means to our business users, we might come up
with a totally different user experience.  
  
We leave the UI as is, and ping the CEO on Lync, inviting her for a
coffee break.  
  
After a bit of obligatory small talk, we start asking questions about
what we're really after.  
  
**Us**: "Can all of the car's characteristics change after the initial
registration?"  
**CEO**: "No, have you ever seen a car change brand, or model through
its lifecycle?"  
  
**Us**: "I can imagine the engine size also belongs to the list of
characteristics that can't be changed after registration?"  
**CEO**: "Oh, it can! We sometimes have the engine of our sports models
tuned to have an edge over the competition. Guys are crazy for
horsepower."  
  
**Us**: "What about changing the color?"  
**CEO**: "If a car has some nasty scratches on it, we sometimes get it
repainted. If we do get it repainted, it's always in one of the colors
available at that moment."  
  
We return to our desk with a far better understanding of what it really
means to change each of the car's characteristics. We discovered a whole
new language, with some important constraints. Neither brands nor models
change after registration. Engines get tuned, increasing their engine
size. A car's color doesn't change; a car gets repainted - always in one
of the available colors.  
  
After iterating on this feedback, we're far more satisfied with the
model; it captures the language far better. Our backend implementation
is not the most important part of the solution though; it's useful to
invest in improving the UI.  
  
After some experimentation we come up with a more [task-based
UI](http://cqrs.wordpress.com/documents/task-based-ui/), something that
looks like this.  
  

[![](/post/images/thumbnails/2013-06-02-accidental-entities-what-about-the-ui-EditCarExplicit.PNG)](/post/images/2013-06-02-accidental-entities-what-about-the-ui-EditCarExplicit.PNG)

  
The UI now does a far better job supporting the language and
communicating its constraints. And with that, we also solved the
original problem that motivated us to ask these extra questions. There
is no value in having the current color in the dropdownlist; we are
better off making the process of having a car repainted explicit.  
  
When we make an effort to really capture the language, this will be
reflected in our model, but also in the UI. This can add tremendous
value. It's not only about making the user experience more intuitive,
but about making a language consistent for thousands of users,
supporting processes and communication throughout the company.  
  
As a disclaimer; sometimes it's fine to just throw up your database.
There's a place and time for anything. But don't let CRUD be the only
tool in your toolbox; you can do much more. Make sure to invest this
extra effort where it matters, where it makes a difference.
