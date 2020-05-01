+++
title = "Interview with Ecbruck"
slug = "2008-11-22-interview-with-ecbruck"
published = 2008-11-22T15:50:00.002000+01:00
author = "Jef Claes"
tags = [ "Interview",]
+++
Ecbruck is Microsoft MVP and is a respected admin of forums.asp.net. He
is known for his high quality replies/solutions. So I thought it might
be intresting to have a chat with him!  
  
<span style="font-weight:bold;">Me: Who are you? Where do you work? On
what project are you working?</span>  
Ecbruck: My name is Ed Bruck. I live in Des Moines, IA, and currently
work as a contractor for the Pioneer HyBred company. During the past
year, I've been working on a 3.5 .Net Windows application which is to
replace an existing financial system for the company. This is long-term
Windows project slated through next Fall, and it may be a while before I
get back to good old Web development.  
As a member of a dozen or so developers, I am charged with working on
one primary function of the application. This includes all front-end,
back-end, and middle-tier work required to complete the task.  
  
<span style="font-weight:bold;">Me: The good old Web development? How
long have you been programming and what other technologies have you been
into? Next to a windows application and asp.net webapplications?  
What is the primary function you are working on? And can you tell me
what you understand under front-end, back-end an middle-tier? The
winform, the database, and your DAL and BLL? </span>  
Ecbruck: My true passion is definetely web development so I really want
to get back to it at some point. That's why I stay so active on this
forum so I don't lose my focus. I've been an active .Net programmer
since the first Beta came out somewhere in 2001. Before that, I was an
ASP developer. I won an HTML class back in the late 90's by sinking a
putt during a job fair. I guess that's what really started it all as I
was so intrigued about the web. Unlike a lot of other developers, most
of my programming and research is done on the job only because I try to
seperate my work and personal life.  
My primary function right now would be building up a services
architecture for our application. When I say front-end, I refer to
building forms, grids, etc... Or DAL is quite extensive and is broken up
into many pieces as we are utilizing a services architecture which rely
hevily on the use of Linq and the EnterpriseLibrary. The BLL would
encompass all of our business rules, validation, etc... We utilize the
DevExpress tools for our front end, and are currently hooked up to a Sql
Server 2005 database.  
  
<span style="font-weight:bold;">Me: How do you use the Enterprise
Library? Is it just a set of best-practices everyone who is working on
the project tries to follow? You also said you are using Linq, but does
the Enterprise Library already supports guidance for Linqs?  
How do you use Linq in your DAL? How do your functions look like? Are
you sending strings and integers as your parameters, or are you using
data transer objects? What are you returning?  
You also said that you try to seperate your work and personal life.
Isn't programming kind of a hobby? Do you do nothing at all at home what
involves programming (like reading forums, ...) </span>  
Ecbruck: We use the EnterpriseLibrary for security, logging,
validation and dependency injection. I would say that we use the library
as more a set of tools which we have used to build the foundation of our
system. We used to use LinqToSql in our application via the DAL, but ran
into many problems with regards to the Context. Therefore, we switched
to writing our own Table mapping files and load our tables directly with
Linq. Most everything in our system is object-based, therefore most of
our DAL methods ONLY accept objects. We however may or may not return
objects depending on the need.  
I think about programming problems at home, but I usually don't write
any code at home. If I get up early enough on the weekend, sometimes
I'll pop into the Forums to do some moderating or answers some
questions, but any code I write would come off the top of my head. What
I usually do is come in early to work to put in some extra time devoted
just to the Forum.  
  
<span style="font-weight:bold;">Me: Can you give some examples of issues
with the Context?If you only use objects in your DAL, where do you store
their classes? Do you store the classes in an extra DTO layer? Are you
creating a different project for each layer?</span>  
Ecbruck: The primary problem with contexts is that if you aren't always
working with the same instance of the context you can end up with a
variety of errors when attempting to insert or update an entity.  
Our objects are primarly stored within a Models project. Our solution
consists of around 60 individual projects. We have individual projects
for each primary function in our system, and within that function we
have a seperate project for the UI, tests, and another for any function
related classes. It's quite a solution.  
  
<span style="font-weight:bold;">Me: To flip the conversation around a
bit. A lot of stuff is happening in the .NET web developement area.
We've got MVC, ADO.NET dataservices, Ajax, Silverlight.. which is all
relatively new.  
What are your opinions on these technologies?  And how do you think a
developer should deal with all these new technologies? It's hard to
keep-up-to date with everything and it is impossible to master all of
these. Should a developer just focus on the stuff he needs everyday or
is it important to keep your interests wide?</span>  
Ecbruck: I've used just enough AJAX to be dangerous, although I haven't
yet dabbled into MVC or Silverlight. Since I'm a Contractor, my position
is that if the company wants me to use Slverlight, then I'll learn it at
their expense. Otherwise, I pretty much stick to the basics and expand
only when needed. Now if a new Framework should come out, then I'll jump
all over that. Now of course this is just me. If you are just learning,
then I'd at least know a little about each as this will make more
well-rounded.  
  
<span style="font-weight:bold;">Me: You are a Microsoft MVP. What does
that mean exactly? What are the benefits you are getting? What are the
responsibilities you have?</span>  
Ecbruck: The MVP is an award that is given to certain individuals who
voluntarily share their real world expertise with the community. It's an
award that you can only be nominated for by your peers. Besides a
certificate, we get complimentary subscriptions to MSDN or TechNet,
access to MVP private newsgroups, and technical support incidents.
There's also a few bucks to spend at the company store. In addition, we
are all invited to Microsoft each spring for the MVP Global Summit where
we get to interact directly with our product groups. Because MVP status
is awarded based on past contributions, Microsoft has no expectations of
MVPs beyond the expectations of courtesy, professionalism, code of
conduct, and adherence to the community rules that are asked of all
Microsoft community members.  
  
<span style="font-weight:bold;">Me: To wrap up this interview. Which is
in your opinion the best Microsoft product and which is the
worst?</span>  
Ecbruck: That's a tough question. I'd have to say I'm very impressed by
Linq and LinqToSql. These two have saved me so much code and time and
are a great addition to any Developer's toolbox. As far as worst goes, I
don't really have just one. Each product has its own flaws which I
usually run accross at one time or another. However, I know too that
testing any product too thoroughly is never enough.  
<span style="font-weight:bold;">  
Thanks alot for the interview. It was very intresting!</span>
