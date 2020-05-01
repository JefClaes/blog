+++
title = "On crime and document stores"
slug = "2012-07-01-on-crime-and-document-stores"
published = 2012-07-01T16:04:00+02:00
author = "Jef Claes"
tags = [ "SQLServer", "NoSql",]
+++
Having worked with several storage paradigms over these last few months
- from flatfiles, to  NoSQL, to the big enterprisey relational databases
-, I have spent plenty of time trying to make sense of all the options
out there. It wasn't until I watched one of the last episodes of [The
Wire](http://en.wikipedia.org/wiki/The_Wire) season 3 that I had an
epiphany regarding modeling data in document stores. Yes, I know, I tend
to take those things home with me.  
  
Somewhere half way through that episode, you see a detective going
through one of those old school, gray and clumsy file cabinets, looking
for a dossier on one of the recent murders. Once he finds the dossier,
he takes it out of the drawer, scribbles down contact information of an
eyeball witness, puts it back in the drawer, and closes the drawer again
with a loud stomp.  
  
And that file cabinet actually isn't very different from a MongoDB
collection; it stores and categorizes documents of the same type, and
the trade-offs you have to consider when modeling dossiers, or
documents, are basically the same.  
  
Let me work the homicide department angle a little further..  
  
A few months later, the murder is still not solved, and one of the
detectives, being out of work, starts working the case again. He walks
over to that same file cabinet, searches the file and goes through the
data one more time. Short on leads, he decides to interrogate the
witness again. So he takes the file, steps in his black Buick, and
drives over to the address scribbled down next to the name of the
witness. When he arrives, after a grueling car ride through morning rush
hour, he finds himself standing in front of a vacant house. Son of a...
He drives over to city hall, waits in line for 24 minutes, gets the new
address, and heads over there. When he gets back to the office, empty
handed, and several hours later, he is determined to prevent this from
happening again. He suggests the other detectives either check and
update their dossiers, or documents, every time somebody moves, or that
they just write down a reference to the person in the dossier, and look
up the data in the file cabinets at city hall. Since going through all
the files every time somebody moves is not feasible, he convinces his
chief to enforce the second option. Over time, people get a hang of it,
and are content to be relieved of stale data in the dossiers. However,
the more they introduce this system in other scenarios, the more they
get frustrated doing the manual look-ups. They now first have to fetch
the document in the file cabinet, and then go through five more
cabinets, just to collect all the bits of the file.  
  
To make matters worse, since it's often hard to find something in the
dossier, chain of command has introduced templates for each of the
documents. Now each document has a fixed schema, a list of fields, of
which each one is in a fixed position on the document, and some of them
are even required. When you want to add a new file, they should be
signed off by your superior first. Sigh.  
  
Getting a taste after work, the detectives are discussing the new
system. 'It's great that we now have a single source of truth, are rid
of stale data, and don't have to manually update everything when
something changes. But damn, all the extra paperwork, all the fuss over
formats and the going back and forth between file cabinets is getting
old quickly.' 'However, I'm happy we could at least keep our OT slips
and expense notes simple; just one document, which we can fill in and
update as we please.' They collegially gulp down their drinks, and
signal the bartender to bring another round.  
  
In this short story, you witnessed the detectives totally ruining their
document store. By normalizing their documents and putting constraints
on the formats, they no longer reap the benefits of using a document
store. Now, they would be far better of with a relational solution.  
  
I hope these analogies made some sense, and maybe made you think about,
or even challenge the SQL dogma. What it all comes down to, is having
enough knowledge to be able to pick the right tool for the job. Each
paradigm has its merits, and as with any other decision in our field,
trade-offs have to be considered. The way you can or want to model your
data isn't the only consideration to make though. While for some it is
scalability and performance that makes NoSQL the obvious choice, for me
it is the simplicity that does it. You don't have to be an IT pro to
install a server instance locally, nor to migrate your application to
the cloud (MongoDB, for example, creates its collections on the fly).
The way you talk to the database also becomes easier; the mismatch
between your code and storage can become a lot smaller, while you also
rid yourself of some of the SQL foo. This doesn't mean that you don't
have to be considerate about how you query your data though; you still
need common sense, but there is a lot less black magic you need to
master.  
  
NoSQL solutions seem to put the developer first; I see NoSQL, and
particularly the document store flavor, not as a silver bullet, but as a
great new asset to my toolbox.
