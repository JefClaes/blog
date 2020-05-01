+++
title = "Data validation, take it seriously"
slug = "2011-08-28-data-validation-take-it-seriously"
published = 2011-08-28T16:30:00.003000+02:00
author = "Jef Claes"
tags = [ "javascript", "Hack",]
+++
We just heard that we might be stuck in Washington DC for a few hours
due to a defect of our plane's backup generator. We decided to notify
our hotel we might be running late.  
  
Surfing to the contact page on their site, we found out that we couldn't
enter our European mobile phonenumber in the required (!) telephone
number field.  
  
Unable to find the direct email address of the hotel, I opened the
developer tools and had a look at the validation script.  
  
[![](../images/thumbnails/2011-08-28-data-validation-take-it-seriously-Afbeelding%2B7.png)](../images/2011-08-28-data-validation-take-it-seriously-Afbeelding%2B7.png)  
Instead of even trying to understand the regular expression, I just
redefined the validation function using the console and retried sending
the message.  
  
[![](../images/thumbnails/2011-08-28-data-validation-take-it-seriously-Afbeelding%2B8.png)](../images/2011-08-28-data-validation-take-it-seriously-Afbeelding%2B8.png)  
Not so suprisingly, judging by the cheesiness of the hotel's website,
our message was sent successfully.  
  
According to the
[OWASP](https://www.owasp.org/index.php/Top_10_2010-Main), the number
one security risk for web applications in 2010 is failing to validate
untrusted data.  
  
Seriously, take data validation seriously. <span
style="font-weight:bold;">Don't make a fool out of yourself. </span>
