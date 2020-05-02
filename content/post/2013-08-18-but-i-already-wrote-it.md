+++
title = "But I already wrote it"
slug = "2013-08-18-but-i-already-wrote-it"
published = 2013-08-18T16:24:00+02:00
author = "Jef Claes"
tags = [ "opinion"]
url = "2013/08/but-i-already-wrote-it.html"
+++
A few weeks ago, we set out to implement a feature that enabled back
office users to set a new rate ahead of time. With our analyst and the
involved user being out of the office for days, we had to solely rely on
written requirements. Two of us skimmed the documents, but didn't take
the time to assure there wasn't any ambiguity - it looked trivial
really. I went back to what I was doing, while my colleague set out to
implement this feature. Going over the implementation together the next
day, he had built something a lot more advanced than I had anticipated.
While I argued that this was a lot more than we needed, we agreed to
wait for feedback from our analyst to return from her holiday.  
  
When our analyst returned, she confirmed that the implementation did a
lot more than we needed. I suggested removing what we didn't really
need. My colleague argued that he now already had put in the effort to
write it, and we should just leave it as is.  

I can relate to feeling good about freshly written code, but that
shouldn't stop you from throwing it away. Code is just a means to an
end; the side product of creating a solution or learning about a
problem. If you really can't let go, treasure it in a gist.

In this particular scenario, one could argue that making the solution
more advanced than it should be, isn't strong enough of an argument to
make a big deal out of it. We're giving the users a little extra for
free, right? 

I cannot stress the importance of simplicity enough; to be simple is to
be great, perfection is achieved not when there is nothing more to add,
but when there's is nothing left to take away, and all of that. Nobody
likes bulky software. Nobody likes fighting complexity all day.

But by only considering the cost of initially writing it, you are also
ignorant of the *true* cost of what appears to be a small little extra
on the surface. Users, developers, designers and analysts alike have yet
another thing to wrap their heads around. More code is not a good thing;
more code to test, more code to maintain. Each feature, how small it may
seem, needs to be taken into account when planning on new ones. Each
feature, definitely an advanced one, makes the cost of training and
support go up. The cost of implementing a feature is just a tiny portion
of what it costs to support that feature through its entire lifetime.

Using this argument, I eventually succeeded in persuading my peer to
dump the ballast. The real lesson for me however, is probably that how
trivial it might have seemed, we could have ruled out any possible
ambiguity in advance by using one of the various tools we have to our
disposal; a smallish white board session or maybe pairing on some high
level tests.