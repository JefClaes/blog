+++
title = "Finding the gaps in a sequence of dates"
slug = "2012-09-23-finding-the-gaps-in-a-sequence-of-dates"
published = 2012-09-23T20:42:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "Linq", ".NET",]
+++
Somewhere earlier this week I had to find the gaps in a sequence of
dates. Admittedly, my first action was to search Stackoverflow for a
clean solution. But since no one asked the question there yet, I had to
implement it myself.  
  
The solution comes in the form of an extension method on
IEnumerable&lt;DateTime&gt;, which takes a lower bound and an upper
bound, and returns an enumerable of dates.  

    public static IEnumerable<DateTime> GetGaps(
        this IEnumerable<DateTime> sequence, DateTime lowerbound, DateTime upperbound)
    {          
        var completeSequence = new List<DateTime>();           
        var tmpDay = lowerbound.Date;

        while (tmpDay <= upperbound.Date)
        {
            completeSequence.Add(tmpDay);
            tmpDay = tmpDay.AddDays(1);
        }
        
        var gaps = completeSequence.Except(sequence.Select(d => d.Date));
        
        return gaps;
    }

I start with building a second - from lower bound to upper bound, thus
gapless - sequence. Then I use the LINQ Except method to compare the
complete sequence to the input sequence, and produce a difference set.  

  

It was only after a few not so successful iterations that I found this -
for me - satisfactory solution though. If I hadn't
[intellistumbled](http://www.jefclaes.be/2012/09/to-intellistumble.html)
upon the [LINQ Except
method](http://msdn.microsoft.com/en-us/library/system.linq.enumerable.except.aspx),
I probably would have ended up with something a lot less elegant.  
  

[![](/post/images/thumbnails/2012-09-23-finding-the-gaps-in-a-sequence-of-dates-LINQExcept.PNG)](/post/images/2012-09-23-finding-the-gaps-in-a-sequence-of-dates-LINQExcept.PNG)

  

This extension method is backed up by a few tests.

    [TestMethod()]
    public void Given_an_empty_sequence_everything_between_bounds_is_a_gap()
    {
        var sequence = new List<DateTime>();            
     
        var actual = sequence.GetGaps(new DateTime(2012, 1, 6), new DateTime(2012, 1, 9));

        Assert.IsTrue(actual.Count() == 4);
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 6)));
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 7)));
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 8)));
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 9)));
    }

    [TestMethod()]        
    public void Given_sequence_with_duplicate_dates_one_is_not_returned_as_gap()
    {
        var sequence = new[] 
        { 
            new DateTime(2012, 1, 6, 10, 0, 0), // double date
            new DateTime(2012, 1, 6, 11, 0, 0), // double date
            new DateTime(2012, 1, 7) 
        };

        var actual = sequence.GetGaps(new DateTime(2012, 1, 6), new DateTime(2012, 1, 9));

        Assert.IsTrue(actual.Count() == 2);
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 8)));
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 9)));
    }

    [TestMethod()]
    public void Given_sequence_with_gaps_the_gaps_are_returned()
    {
        var sequence = new[] 
        { 
            // gap
            new DateTime(2012, 1, 4), 
            new DateTime(2012, 1, 5), 
            // gap
            new DateTime(2012, 1, 7, 11, 10, 1) 
            // gap
        };

        var actual = sequence.GetGaps(new DateTime(2012, 1, 3), new DateTime(2012, 1, 8));

        Assert.IsTrue(actual.Count() == 3);
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 3)));
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 6)));
        Assert.IsTrue(actual.Contains(new DateTime(2012, 1, 8)));
    }

    [TestMethod()]
    public void Given_sequence_with_no_gaps_an_empty_enumerable_is_returned()
    {
        var sequence = new[] 
        {                
            new DateTime(2012, 1, 4), 
            new DateTime(2012, 1, 5),                 
            new DateTime(2012, 1, 6)                 
        };

        var actual = sequence.GetGaps(new DateTime(2012, 1, 4), new DateTime(2012, 1, 6));

        Assert.IsFalse(actual.Any());
    }

Do you know of a better way to do this?
