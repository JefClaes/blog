+++
title = "Testing DI bootstrappers"
slug = "2012-02-06-testing-di-bootstrappers"
published = 2012-02-06T08:59:00+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2012/02/testing-di-bootstrappers.html"
+++
While your [Dependency Injection](http://martinfowler.com/articles/injection.html)
bootstrappers - being responsible for gluing your application together -
are a vital part of your application, they are seldom put under test. I
don't see any reason why they shouldn't be though. The cost of these
tests is negligible, definitely if you compare it to the cost of the
often catastrophical outcome of bugs in your bootstrappers.  
  
I encourage you to take a look at the commit history of your DI
bootstrappers; I bet they change a lot. Wouldn't it be nice to have a
set of tests that proves that the dependency container still behaves
like you expect it to at runtime? Next to proving correctness, I think
writing these tests also helps you discover various behaviours of your
DI container, which is a valuable investment in itself.  

Let me show you a few tests that I wrote to put my [ASP.NET MVC
Ninject](https://jefclaes.be/2011/10/ninjecting-mvc3.html)
bootstrapper under test.  
  
I started by opening up the Ninject bootstrapper, making the
`CreateKernel` method public.

```csharp
public static IKernel CreateKernel()
{
    var kernel = new StandardKernel();
    
    kernel.Bind<IEntryService>().To<EntryService>();

    return kernel;
}
```

In the test class, I used the [TestInitialize attribute](http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.testtools.unittesting.testinitializeattribute(v=vs.80).aspx)
to initialize a new instance of the kernel before every test. I'm not
sure this is really necessary, but I want to avoid that my tests
experience side-effects of a previous test.  

```csharp
[TestInitialize]
public void Setup()
{         
    _kernel = NinjectMVC3.CreateKernel();
}        
```

Needless to say, the first test should prove that an implementation of
the `IEntryService` interface can be resolved. The behaviour I observed
while playing with this case, is that Ninject throws a
`Ninject.ActivationException` when the implementation can't be resolved.  

```
Ninject.ActivationException: Error activating IEntryService  
   No matching bindings are available, and the type is not
   self-bindable.  
   Activation path:  
       Request for IEntryService  
   
Suggestions:  

1.  Ensure that you have defined a binding for IEntryService. 
2.  If the binding was defined in a module, ensure that the module has
     been loaded into the kernel.
3.  Ensure you have not accidentally created more than one kernel.
4.  If you are using constructor arguments, ensure that the parameter
     name matches the constructors parameter name.
5.  If you are using automatic module loading, ensure the search path
     and filters are correct.
```

So to test whether an implementation can be resolved, I just make sure
no exceptions are thrown on resolving the dependency.  

```csharp
[TestMethod]
public void Test_IEntryService_Can_Be_Resolved()
{
    AssertDoesNotThrowWhenResolved<IEntryService>();
}
```

The `AssertDoesNotThrowWhenResolved` method is a helper method which tries
to resolve a dependency of T and asserts that no exceptions are thrown
while doing so. The assertion is borrowed from
[Xunit](http://xunit.codeplex.com/) ([package available on
Nuget](http://nuget.org/packages/xunit)).  

```csharp
private void AssertDoesNotThrowWhenResolved<T>() 
{
    Xunit.Assert.DoesNotThrow(() => _kernel.Get<T>());
}
```

A second useful test is testing the lifetime of the resolved
implementation. For most of my dependencies, I expect a new instance
every time they are resolved. This test looks like this.  

```csharp
[TestMethod]
public void Test_IEntryService_Is_New_Instance()
{
    AssertNewInstanceIsResolved<IEntryService>();
}
```

The `AssertNewInstanceIsResolved` method is another helper method which
resolves two instances of T and asserts they are not the same.  

```csharp
private void AssertNewInstanceIsResolved<T>()
{
    var instance = _kernel.Get<T>();
    var secondInstance = _kernel.Get<T>();

    Assert.AreNotSame(instance, secondInstance);
}  
```

That's it. While these tests are very cheap to write, they do provide
great value. I can imagine testing more complex bindings, like
contextual bindings, taking a bit more time to set up, but the value of
these tests increases proportionally.  
  
**Do you put your DI bootstrappers under test?** If you don't, why not?
