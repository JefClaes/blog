+++
title = "Interview with Curt Christianson (Part II)"
slug = "2009-01-12-interview-with-curt-christianson-part-ii"
published = 2009-01-12T20:34:00.002000+01:00
author = "Jef Claes"
tags = [ ".NET", "ASP.NET", "Interview",]
+++
This is part II of the interview with [Curt
Christianson](http://darkfalz.com/). For Part I go
[here](http://jclaes.blogspot.com/2009/01/interview-with-curt-christianson-part-i.html).  
  

### Part 2: Technology

  

<span style="font-weight: bold;">Let me ask you some general questions
about building a web application. What is your advise on setting up the
layers of a web application. In the web application I'm currently
working on we chose a not so standard architecture I guess. We have
multiple "modules", which are folders in practice. In the root of these
modules we hold our aspx pages. For each module we have three folders:
BLL, DAL and Controls. In our BLL we hold our objects, some logic, ...
In our DAL we stock our typed datasets based on stored procedures. We
divided our pages into Controls, because our pages are pretty big. We
access all of our data methods in the controls, using ObjectDataSources
based on the typed datasets. We try to make as much use as possible from
the ObjectDataSources using the designer, some custom things are done in
code-behind. But we found out that this architecture is a hassle. It
doesn't give a much as control as we'd like and debugging/logging really
is a pain in the ass. A problem is that we can't use the designer as
much as we want, because we needed to add more functionality/business
logic than the designer allows us. With the result that some of the
logic is in the aspx page and some in the code behind. What is in your
opinion a better architecture?</span>  
<span style="font-weight: bold;">  
</span>From the sound of it you are running into some of the same
circumstances I did. I found that using the pre-build datasources were
WAY too much limitation for me. I tend to toss them out right away and
switch to a more manual approach. This does make more work (you have to
do sorting and paging yourself) but other than that I found it a lot
easier to work with.  
I used to be a fairly strong believer in the 3 tier approach but have
come to the conclusion that for 99% of work that's done you are best off
with a simple 2 tier approach. There is no real need to seperate the
Business and Data layers. Combining the object definitions with the
calls to the database and mixing in the validation from the business
perspective all at once seemed the best bet. I still break the pieces
out into seperate methods but I've combined them all into one set of
classes instead of 2 distinctive ones.  
Now, as far as controls go... my rule is simple... if I use it more then
once it's a control...if not, then it's coded into the page. I never
make a code block into a control unless there is a reason to...otherwise
it's extra work for yourself. That said... i was VERY guilty of the
opposite. I used to take every Asp.Net control and make a custom control
that inherited from the native one. Then I would only use the custom
one...just in case some day I wanted to enhance it (I almost never did)
so eventually I stopped that nonsense.  
  
<span style="font-weight: bold;">What is your opinion on using stored
procedures? Some say using stored procedures is oldschool.</span>  
<span style="font-weight: bold;">  
</span> I've really shifted away from it. In the past, with previous
versions of MS SQL you really wanted to use them as much as you could
for perf reasons, but now that's really not the case. What I've done is
actually make all my SQL statements simply constants in my application.
They are all in one class file so they are easily found and tweaked when
needed. I do parameterize everything though...this is a MUST in my
book.  
  
<span style="font-weight: bold;">About using the sql queries in your
classes.. Are you simply returning datasets from your functions and
binding these to your controls? Are you planning on using LinqToSql in
your future projects for this? What is your opinion on Linq? I also
wonder if you have any idea what Microsoft's is opinion on the issue of
not being able to use the datasources for more complex things, because
basically that's what they are designed for, to reduce development time.
What is your opinion on this. Should Microsoft do something about
it?</span>  
  
I used to use datasources a lot but since vs2005 I discovered
Generic.List(of ). This has been my favorite thing. Everything now is
bound to a List(Of myObject), hence the custom sorting and paging. I've
used LinqToSql in the past to play around but the limitations were too
great. My objects are often complex and it didn't really handle them
well. The new Entity Framework stuff looks more promising though, and it
looks like LinqToSql is already "obsoleted" in the framework anyways.  
I don't think these datasources were really meant for anything other
than small-midsized applications (complexity wise). They were always
meant (in my opinion only of course) to be for those times when you need
it fast and easy and you have a one-to-one relationship with your
datamodel and application classes.  
  
<span style="font-weight: bold;">You also co-edited a book about AJAX?
AJAX is an awesome technology. "Javascript that works". I really think I
am not using AJAX to it's full potential though. What I am using is the
UpdatePanel (which is the best control ever) and the AjaxControlToolKit.
That's it. What am I missing here?</span>  
<span style="font-weight: bold;">  
</span>I wouldn't say edited.. but reviewed. It's different, but same
basic concept. Personally, the UpdatePanel is THE heart of Ajax. Beyond
that it's all secondary. So, with that I'd say you are actually right on
track with what you need for Ajax.  
  
<span style="font-weight: bold;">The other book you reviewed was on WPF,
right? What are your thoughts on WPF? Is it gonna take of soon? Is this
the end for WinForms?</span>  
  
I've actually reviewed at least a dozen different books over the last
few years.  
The WPF one was a while ago but it's just coming out in published
copy.  
For me WPF is something that's interesting but not something that I will
probably ever do much with. Is \*it\* the end of WinForms... absolutely
not. Is it \*part\* of the beginning of the end... sure.  
  
Now...if I was to take a stab at the prediction of development here's
what I see. WinForms and WebForms will both really "die off" and what
you'll see come out of the ashes will be a conglomeration of the two.
More like a child of the two rather than one taking over the other. The
differentiation between two negligible. The user will never really know,
or care, where they are operating. It's not really "cloud" computing
(that's just poor PR in my opinion) but rather a melding of the two.
With things like Ajax, WPF, WCF and all the other acromyms, we are on
the way. I think in the next 2 years you will see some real distinct
breakthroughs, especially with hand-held platforms, that will be the
hybrid we're after. Take those and extend them to the larger CPU
capacity of the home PC and you get some idea of what could be done.  
  
<span style="font-weight: bold;">Are you thinking of more Surface like
interactivity? </span>  
<span style="font-weight: bold;">  
</span>Not really... surface is cool, and definitely part of it. The
multiple-input, touch-sensitive piece will definitely find it's place
with the new scheme but I don't think we're really gotten at the core of
the new stuff yet, it's still on the verge of being discovered (or
tucked in a lab somewhere). Think of a meld between the PC,
Laptop/Tablet and SmartPhone, but all as one device with all the best
features of them all and integrated into a form factor yet to be
determined (I have ideas but still to early to say).  
  
<span style="font-weight: bold;">I think that's a good line to end this
interview! Thank a lot.</span>
