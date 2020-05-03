+++
title = "Is serialization really that expensive?"
slug = "2012-08-22-is-serialization-really-that-expensive"
published = 2012-08-22T13:19:00+02:00
author = "Jef Claes"
tags = [ "opinion",]
url = "2012/08/is-serialization-really-that-expensive.html"
+++

While wading through an exotic codebase, I stumbled upon a static class
named Convert. This class contained somewhere around 2700
(non-generated) lines of code, where each method manually converted some
object to a simple textual representation. These methods were then used
to convert requests and reponses to and from a remote third party
service before logging them to the database for auditing reasons.  

```csharp
public static class Convert
{
    public static string PaymentRequest(PaymentRequest req)
    {
        var sb = new StringBuilder();

        sb.Append("Reference: " + req.Reference + " - ");
        sb.Append("NumberOfLicenses: " + req.NumberOfLicenses + " - ");
        sb.Append("PricePerLicense: " + req.PricePerLicense + " - ");
        sb.Append("CardNumber: " + req.CardNumber + " - ");
        sb.Append("Address: " + req.Address);

        return sb.ToString();
    }
}
```

My first thoughts were something along of the lines of "What the.. this
is insanely stupid code." This must be a PITA to maintain and be
extremely error-prone. Looking at the solution now, it looks simple
enough to move that to some infrastructure and have the conversion done
by something more generic. [Serializing to JSON](http://james.newtonking.com/projects/json-net.aspx) comes to mind; interpretable by man ánd machine.  
  
Trying not to jump to conclusions, I looked for one of the remaining
team members, and asked why they made that decision. "Well", he said,
"Those remote service calls are expensive as is; it's a slow connection,
we have to encrypt everything going over the wire, and we can't make
them asynchronously. We optimized where we could. Including logging."  
I asked if they found serialization to be so expensive that it could
warrant all the monkey code. He said yes, but that he couldn't vouch for
the decision since *they never measured*.  
  
Later that day, I took five minutes to see how the two really compare. I
have [this code snippet](http://stackoverflow.com/questions/1047218/benchmarking-small-code-samples-in-c-can-this-implementation-be-improved)
lying around if I quickly want to profile something.  

```csharp
static void Profile(string description, int iterations, Action func)
{
    // clean up
    GC.Collect();
    GC.WaitForPendingFinalizers();
    GC.Collect();

    // warm up 
    func();

    var watch = Stopwatch.StartNew();
    for (int i = 0; i < iterations; i++)    
        func();    
    watch.Stop();
    
    Console.Write(description);
    Console.WriteLine("Time Elapsed {0} ms", watch.ElapsedMilliseconds);
}
```

I picked an average sized object graph and ran the benchmark.  

```csharp
var req = new PaymentRequest()
{
    Reference = "ABC123",
    NumberOfLicenses = 3,
    PricePerLicense = 15.99,
    CardNumber = "123456",
    Address = "Sunset Boulevard"
};

Profile("Serializing a request.", 1, () =>       Newtonsoft.Json.JsonConvert.SerializeObject(req));
Profile("Doing it manually.", 1, () => Convert.PaymentRequest(req));
```

This yielded following results.  

```
Serializing a request. Time Elapsed 0 ms
Doing it manually. Time Elapsed 0 ms
```

Neglectable.  
  
Turning up the number of iterations to 100 produces following results.  

```
Serializing a request. Time Elapsed 9 ms
Doing it manually. Time Elapsed 1 ms
```

This time around, we see a huge relative difference; doing it manually
is 9 times as fast. The absolute difference is still neglectable
though.  
  
As it turns out, for this specific scenario, with [this specific serialization library](http://james.newtonking.com/projects/json-net.aspx), the
overhead of serialization would be very tolerable. Other serialization
libraries might produce [less tolerable results](https://lh3.googleusercontent.com/-bZNx64Vindc/UDS-q5630JI/AAAAAAAABYk/DeNUYA9ARMs/s611/jsonperformance.png) though. It's important to measure this stuff; I'm (re)learning almost daily that *assuming is a mistake*.  

> Measurement is the first step that leads to control and eventually to
> improvement. If you can't measure something, you can't understand it.
> If you can't understand it, you can't control it. If you can't control
> it, you can't improve it. - H. James Harrington