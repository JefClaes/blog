+++
title = "Passing the AWS Certified Solutions Architect exam"
slug = "2017-12-15-passing-the-aws-certified-solutions-architect-exam"
published = 2017-12-15T20:34:00+01:00
author = "Jef Claes"
tags = []
+++
Before last week, the only certification exam I ever passed was the
Microsoft .NET Framework Application Development Foundation
certification. This was almost eight years ago. My manager back then
thought getting certified was the best way for me to get a raise. It
would be a win-win. I for one would learn something along the way, and
the company would have less trouble keeping its Microsoft Gold
partnership. As far as I remember, I spent a good six months reading,
studying and memorizing [this 794 pages thick
book](https://www.amazon.com/MCTS-Self-Paced-Training-Exam-70-536/dp/0735626197).
Although the book did teach me a fair amount of solid .NET framework
internals, most time was spent force feeding myself the ins and outs of
framework API's you only need once in a blue moon and should just Google
for when needed.  
  
This time around though, it was my own decision to get certified. Mid
2016, our components were getting more and more structured in a way that
allowed us to deploy them away from our on-premise data center.
Components that didn't own data bound to a specific territory by
regulatory requirements and that would allow for some down-time were the
obvious candidates.  
  
Moving some of our infrastructure to the cloud, we had a few goals in
mind:  

-   Take advantage of managed cloud services to reduce operation cost
    significantly.
-   More freedom to scale up or down. The structure of  the contracts
    with our data center (and regulations that require us to own our own
    racks) generally forces us to over provision our infrastructure.
    Making changes halfway the contract takes time and is costly.
-   Ease into learning how to run software on the cloud for when we move
    to other markets or when we build services that have less strict
    territoriality constraints.

  
Getting started with AWS is easy enough. Starting an EC2 instance,
attaching a disk, using a managed database, configuring a load balancer
is child's play. But when it came to networking, security,
fault-tolerance and properties guaranteed by AWS, I had a lot of
questions. I hoped to find answers going over the AWS Certified
Solutions Architect material. Why not set myself an artificial goal and
get certified while I was at it?

  

After three months of studying, I passed the exam with a score of 95%.
Here's a list of the resources I used, including how much money and time
were spent.  
  
**Exam Blueprint**  
**  
**You should go over the exam blueprint to understand what they expect
you to know to pass the exam. It's a good idea to go over the document
while studying and to tick off domains you feel comfortable with.  
*  
Money spent: €0, time spent: 30 minutes*  
*  
***A Cloud Guru**  
**  
**A good collection of short videos and mini-exams covering all the
topics needed to pass the exam. Details that require extra attention to
pass the exam are highlighted throughout the course.  
  
You can get the videos on [acloud.guru](https://acloud.guru/) for €99. I
got it through [Udemy](https://www.udemy.com/) for only €10. Worth every
cent.  
  
*Money spent: €10, time spent: 26 hours*  
*  
***FAQs and Whitepapers**  
**  
**AWS advises you to read a [specific set of whitepapers and
FAQs](https://aws.amazon.com/certification/certification-prep/). The
material can be a bit dry, but it's extremely useful. Not just to pass
the exam, but to avoid nasty surprises in production.  
  
*Money spent: €0, time spent: 6 hours*  
*  
***AWS Open Guide**  
  
An [open-source effort](https://github.com/open-guides/og-aws) to
document real world experiences running environments on AWS.  
  
*Money spent: €0, time spent: 1 hour*

  

**Whizzlabs**

**  
**

Somewhere around [500 practice questions](https://www.whizlabs.com/)
that tease out the topics you don't completely master. When I got a
question wrong, I would read up on the topic and play around in the AWS
console until I felt like I got it.

  

Although there were some questions that were very similar, you can't
pass the exam by just studying these questions.

  

*Money spent: €20, time spent: 12 hours*

*  
*

**Exam Guru**

**  
**

Mobile app affiliated with A Cloud Guru containing more practice
questions. These are less scenario based and less in-depth. The
Whizzlabs questions are much more in the direction of what to expect on
the actual exam. Disappointing to be fair.

  

*Money spent: €20, time spent: 2 hours*

*  
*

**Test exam**

**  
**

A small set of questions provided by AWS in the style of the actual
exam. This was very much a waste of time and money. Whizzlabs had copied
all of these questions word for word.

  

*Money spent: €20, time spent: 20 minutes*

*  
*

**Test day**

**  
**

The least enjoyable part of the experience.  55 multiple choice
questions need to be answered in 80 minutes. Half of the questions are
quite straight forward. The other half are more involved. For the longer
questions, I first read the answers and wrote down the options. For then
to read the question and strike through the options that definitely were
not a part of the answer. This helped me to focus on the important bits
of the question and to gain momentum plowing through the questions at a
steady pace. I finished with 25 minutes left.

  

*Money spent: €135, time spent: 90 minutes. Extra money spent on parking
in the city center of Brussels: €10, searching for a spot: 60 minutes*

*  
*

*  
*

In short... Go over the material, practice, take notes, practice some
more, review your notes until you get sick of them.
