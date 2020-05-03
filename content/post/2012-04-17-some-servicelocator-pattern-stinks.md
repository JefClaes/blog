+++
title = "Some Servicelocator pattern stinks"
slug = "2012-04-17-some-servicelocator-pattern-stinks"
published = 2012-04-17T20:33:00+02:00
author = "Jef Claes"
tags = [ "opinion", "code"]
url = "2012/04/some-servicelocator-pattern-stinks.html"
+++
I have been working on a somewhat legacy codebase which makes use of the
[Servicelocator
pattern](http://martinfowler.com/articles/injection.html#UsingAServiceLocator).
Although I always thought of [Dependecy
Injection](http://martinfowler.com/articles/injection.html#FormsOfDependencyInjection)
to be the superior pattern, I was pleased to find some [Inversion of
Control](http://martinfowler.com/articles/injection.html#InversionOfControl)
implementation in there. Working with the codebase, I discovered first
hand how easily, when used without caution and discipline, the
Servicelocator pattern can introduce code rot.  
  
I will walk you through some of the issues I have with the
Servicelocator pattern, mostly looking at it from a test perspective.
It's interesting how you can often quickly discover friction in a
codebase by just looking at, or writing, tests.  
  
The first thing that rubs me the wrong way is that by using the
Servicelocator pattern, you make each class dependant on the
servicelocator, degrading the purity of the models. Although this is a
conceptual consideration, it considerably affects development.  
  
What I really like about Dependency Injection is that you can look at
the constructor (or properties) from a class and instantly know its
dependencies. The Servicelocator pattern makes it too easy to hide
them.  
  
To demonstrate some of the beef I have with the Servicelocator pattern,
I wrote a FireStation class which has one public method Alert. I chose
an example which is not the de facto OrderService or ShoppingBasket
implementation, but which still is small enough to grasp easily.  
  
So let's have a look at this FireStation class. I know it's a
ridiculously naïve implementation, but good enough as an example.  

```csharp
public class FireStation
{
    public void Alert(Incident incident)
    {
        SendPagerMessage();
        SendEmail();

        if (incident.Priority == IncidentPriority.High)            
            ActivateSiren();                        
    }

    private void SendPagerMessage()
    {
        ServiceLocator.Current.GetInstance<IPagingTerminal>().SendMessage();
    }

    private void SendEmail()
    {
        ServiceLocator.Current.GetInstance<IMailServer>().SendMailMessage();
    }

    private void ActivateSiren()
    {
        ServiceLocator.Current.GetInstance<IImmoticaServer>().ActivateSiren();
    }
}
```

There is one public Alert method, which takes an Incident instance, and
uses three alarmation channels to alert firemen: paging, email and a
siren.  
  
So, let's imagine I wanted to test whether the siren is activated when
there is a high priority incident. I would just start writing the test,
to ultimately find out I have no idea what to assert.  

```csharp
[TestMethod()]        
public void Alert_activates_the_siren_when_the_priority_is_high()
{
    var fireStation = new FireStation();

    fireStation.Alert(new Incident(IncidentPriority.High));

    Assert.Inconclusive("How can I verify the siren is activated?");
}
```

Looking at the collapsed method definitions, I still don't know. There
is no constructor, so the dependencies aren't resolved in there. Nothing
left to do but inspect the Alert method content, and look at the
ActiviateSiren method implementation. That's where I eventually find out
I need to mock the IImmoticaServer interface to assert the
interaction.  
  
So I do that, by creating the mock, setting up the container and setting
it as the provider for my servicelocator.  

```csharp
[TestMethod()]    
public void Alert_activates_the_siren_when_the_priority_is_high()
{            
    var immoticaServer = new Mock<IImmoticaServer>();

    var kernel = new StandardKernel();
    kernel.Bind<IImmoticaServer>().ToConstant(immoticaServer.Object);
    
    ServiceLocator.SetLocatorProvider(() => new NinjectServiceLocator(kernel));    

    new FireStation().Alert(new Incident(IncidentPriority.High));

    immoticaServer.Verify(i => i.ActivateSiren(), Times.Once());
}
```

Now I'm polluting my test with responsibilities it shouldn't really care
about. I could probably move that into some infrastructure or the test
setup, but still, I'm writing code that could be easily averted.  
  
Anyways, I should now be able to verify the interaction with the
IImotticaServer implementation. Boom, red test. You probably figured
this one out already, but if I hadn't expanded the private methods, you
would have had no idea that I needed two extra stubs to make the test
pass; one for the IPagingTerminal dependency and one for the IMailServer
dependency.  

```csharp
kernel.Bind<IPagingTerminal>().ToConstant(new Mock<IPagingTerminal>().Object);
kernel.Bind<IMailServer>().ToConstant(new Mock<IMailServer>().Object);
```

After binding these two dependencies the test finally turns up green.  
  
This development experience was horrible. The Servicelocator pattern
fails at making it easy for me to discover dependencies, leading to an
interrupted test flow. Another harmful side-effect is that it also
becomes harder for me to read code and understand the high level
interactions between objects, without getting knees deep into the
implementation details.  
  
By hiding your dependencies, you also promote ignorance to a problematic
amount of dependencies. I discovered three in this example, but as this
class grows, more and more of them will be buried inside the method
implementations.  
  
To make it easier to avoid and spot these smells earlier on, without
dropping the Servicelocator pattern as a whole, you could move service
resolution to the constructor. This isn't a completely safe refactoring
though. It's possible that some instantiations are expensive, and should
be implemented to be lazy initialized.  
  
There is one more annoyance I would like to spout in this post. The
Servicelocator pattern doesn't encourage good OO. I'm not an OO purist,
but seeing dozens of static classes resolving their dependencies through
a servicelocator sends shivers down my spine. I would rather pick an
Inversion of Control technique which basically makes it impossible to do
this.  
  
This post turned out to be longer than I expected it to be, and I even
left some annoyances uncovered. I hope I succeeded in explaining my beef
with the Servicelocator pattern. I trust that the general consensus will
soon dictate that this pattern easily leads to marginal code, and that
it actually is an anti-pattern which should be avoided if possible.
