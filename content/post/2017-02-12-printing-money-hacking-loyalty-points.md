+++
title = "Printing money - hacking loyalty points"
slug = "2017-02-12-printing-money-hacking-loyalty-points"
published = 2017-02-12T00:20:00.003000+01:00
author = "Jef Claes"
tags = []
+++
At work, we've all grown quite vigilant when it comes to customers
trying to cheat the system. A necessary trait when working in a domain
where money flows back and forth and customers are always trying to find
an edge that will turn the tables.  
  
While most tend to leave this mindset at work, one colleague in
particular, is always probing, trying to find cracks in the surface of
everyday models. Years of practice have made him exceptionally good at
it too. When you want more than a shallow review of your design, you go
see him.  
  
I happened to be a part of his last quest, in which we reverse
engineered a case of security by obscurity involving a large supermarket
chain.  
  
A bit of backstory first. This supermarket - as many others - offers a
loyalty program. In return for your data, you earn one point per two
euros spent. As soon as you've saved up 500 points, you get a 5 euro
coupon which you can use to get a discount or to buy an item in their
loyalty shop. To identify yourself, you receive a card which you show to
the cashier on checkout or which you scan yourself when using the
self-checkout. When you forgot your card in the car or at home, they
print a code on the receipt. This allows you to claim your points
afterwards by handing it to the cashier, or again by scanning it
yourself at the self-checkout.  
  
In this example, we purchased something small without using our loyalty
card. The item cost less than four euros, earning us one meager loyalty
point. If you take a closer look at the ticket, you can see the amount
of points being repeated at the tail of the barcode.  
  

[![](../images/thumbnails/2017-02-12-printing-money-hacking-loyalty-points-ticket.png)](../images/2017-02-12-printing-money-hacking-loyalty-points-ticket.png)

  

  

If you're familiar with the anatomy of some of the established barcode
standards, you might notice they're using the UPC symbology to encode
loyalty points.

  

[![](../images/thumbnails/2017-02-12-printing-money-hacking-loyalty-points-upc.gif)](../images/2017-02-12-printing-money-hacking-loyalty-points-upc.gif)

  

After proving the manufacturer code was connected to the store the
ticket was printed at - by purchasing multiple products from different
branches, we figured we could just go ahead and forge our own loyalty
points. A quick Google search and a printer were all the tools we
needed.

  

[![](../images/thumbnails/2017-02-12-printing-money-hacking-loyalty-points-forge.PNG)](../images/2017-02-12-printing-money-hacking-loyalty-points-forge.PNG)

  

So we first purchased two products on two different days. This gave us a
ticket worth one point and another one worth two points. We printed our
own barcode worth three points, and claimed it at the self-checkout. We
weren't stopped by security on our way out, and the points were credited
to our points wallet, so I guess it was a successful experiment.

  

To be fair, if it wasn't for the self-checkout option, it would be much
harder to get away with this. If we had to hand over our ticket to a
human, we would have needed to counterfeit a lot more than just the
barcode. There are reasons it's so incredibly hard to print fake money. 

  

The system used is quite simple; both from a customer perspective as a
technical perspective. It's a lightweight stateless model which should
hardly require any maintenance.

  

If you wanted to make this system more secure - not necessarily bullet
proof, I can think of two obvious options:

  

-   Leave the validation of points to humans. I'm not sure how hard it
    would be to make a high quality copy of a ticket with lots of points
    on it. 
-   Spawn a new state machine identified by a random token each time you
    hand out points. This state machine allows points to be claimed and
    to expire. 

  

Please chime in if you know of battle-tested models for this type of
functionality. 

  

Closing off, we didn't do any harm during our research: we didn't take
more than we paid for.
