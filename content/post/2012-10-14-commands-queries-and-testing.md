+++
title = "Commands, queries and testing"
slug = "2012-10-14-commands-queries-and-testing"
published = 2012-10-14T17:45:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC", ".NET", "Refactoring", "Ramblings",]
+++
*Also read:*  

1.  [*Self-contained commands with
    dependencies*](http://www.jefclaes.be/2013/01/self-contained-commands-with.html)
2.  [*Separating command data from logic and sending it on a
    bus*](http://www.jefclaes.be/2013/01/separating-command-data-from-logic-and.html)

We need abstraction, but the amount of abstraction we really need
depends, and should be assessed on a case-by-case basis. It seems
advisable to grow abstractions, and to introduce them gradually.  
  
That being said, in this post I want to talk about an architecture that
tries to limit abstractions to solely commands and queries.  
  
It all starts with two small pieces of infrastructure: a command and a
query. A command performs an action, and can change state, while a query
should only return data, and not alter any state; [basic command and
query
separation](http://en.wikipedia.org/wiki/Command-query_separation).  

    public abstract class Command
    {
        public abstract void Execute();
    }

    public abstract class Query<T>
    {
        public abstract T Execute();
    }

Now imagine, we are doing something with accounts, and we want to have a
command that can withdraw money from an account, and a query that
returns the total amount available on an account. The assumption is that
we're only talking with a database.  

    public class WithdrawAmountCommand : Command
    {
        public WithdrawAmountCommand(string user, int amount)
        {
            if (string.IsNullOrEmpty(user))
                throw new NullReferenceException("user");                
        
            User = user;
            Amount = amount;
        }

        public string User { get; private set; }

        public int Amount { get; private set; }

        public override void Execute()
        {
            // Implementation
        }
    }

We inherit from the Command class, and pass in its input arguments via
the constructor. We put our actual implementation in the Execute method
override. For the query, we do something very similar.  

    public class TotalAmountQuery : Query<int>
    {
        public TotalAmountQuery(string user)
        {
            if (string.IsNullOrEmpty(user))
                throw new NullReferenceException("user");
        
            User = user;
        }

        public string User { get; private set; }

        public override int Execute()
        {
            return 100; // Should be an actual implementation
        }
    }

Now, if we would use this in ASP.NET MVC, we would end up with clean and
compact controllers. Have a look at the action Foo, which first
withdraws 25 euros, to then redirect to a warning action if the balance
is negative, or to redirect back to the index action when it's positive.
Very readable, right?  

    [HttpPost]
    public ActionResult Foo(string user)
    {
        new WithdrawAmountCommand(user, 25).Execute();

        var totalAmount = new TotalAmountQuery(user).Execute();

        if (totalAmount < 0)
            return RedirectToAction("Warning");

        return RedirectToAction("Index");
    } 

There are several advantages I experienced while applying this pattern.
First, there are less layers of abstraction, while not neglecting
readability nor maintainability. In a more conservative approach, I
would end up with an account repository, abstracting my data access, and
probably also an account service, abstracting my business logic. This
repository, and service, would have multiple methods, which probably
solve related, yet different problems. I would have to wade through all
the methods in these classes to find the operation that is relevant for
me.  
  
When you model each operation as a class on its own, you define it more
explicitly. And you're able to adhere to the Single Responsibility
principle even more. Practically, it's now also easier to locate an
operation in the codebase by just looking at the solution explorer.  
  
One last, but not unimportant, advantage I see, is that it gets easier
to group queries and commands per functionality and context.  
  
We could test the example above against the actual implementation, and I
don't see anything wrong with that per se, but it isn't always that
practical; the setup of your queries can be heavy and complex,
performance of your tests might be suffering etc.. One technique would
be to create an interface per query and command and inject them, but
that seems cumbersome, and ceremony heavy, and that isn't something I'm
willing to do.  

  

Something in between could be introducing a Command- and QueryHandler.

    public interface ICommandHandler
    {
        void Execute(Command command);
    }

    public class CommandHandler : ICommandHandler
    {
        public void Execute(Command command)
        {
            command.Execute();
        }
    }

    public interface IQueryHandler 
    {
        T Execute<T>(Query<T> query);
    }

    public class QueryHandler : IQueryHandler
    {
        public T Execute<T>(Query<T> query)
        {
            return query.Execute();
        }
    }

These could be injected into the controller, and be used as an
intermediary to execute queries and commands for us.  

    public class HomeController : Controller
    {
        private readonly IQueryHandler _qryHandler;
        private readonly ICommandHandler _cmdHandler;

        public HomeController()
        {
            _qryHandler = new QueryHandler();
            _cmdHandler = new CommandHandler();
        }

        public HomeController(
            ICommandHandler cmdHandler, IQueryHandler qryHandler)
        {
            _cmdHandler = cmdHandler;
            _qryHandler = qryHandler;
        }

        [HttpPost]
        public ActionResult Foo(string user)
        {
            _cmdHandler.Execute(new WithdrawAmountCommand(user, 25));

            var totalAmount = _qryHandler.Execute<int>(new TotalAmountQuery(user));

            if (totalAmount < 0)
                return RedirectToAction("Warning");

            return RedirectToAction("Index");
        }
    }

This technique would make it possible, and easy, to use stubs or mocks
for queries and commands.  

    [TestMethod()]
    public void Foo_should_withdraw_25_euros_from_the_account_of_jef_claes()
    {
        var cmdHandler = new Mock<ICommandHandler>();
        var qryHandler = new Mock<IQueryHandler>();

        var controller = new HomeController(
            cmdHandler.Object, qryHandler.Object);

        controller.Foo("JefClaes");

        cmdHandler.Verify(
            h => h.Execute(It.Is<WithdrawAmountCommand>(
                c => c.Amount == 25 && c.User == "JefClaes")));
    }

    [TestMethod()]
    public void Foo_should_redirect_to_a_warning_page_when_amount_negative()
    {
        var cmdHandler = new Mock<ICommandHandler>();
        var qryHandler = new Mock<IQueryHandler>();

        qryHandler
            .Setup(h => h.Execute<int>(It.IsAny<TotalAmountQuery>()))
            .Returns(-1);

        var controller = new HomeController(cmdHandler.Object, qryHandler.Object);
        var result = (RedirectToRouteResult)controller.Foo("JefClaes");

        Assert.AreEqual("Warning", result.RouteValues["action"]);
    }

I don't think this should be introduced as an application-wide thing
necessarily, but it could only be used when testing the actual
implementation becomes hard or awkward.  
  
**But what if I need to inject dependencies into my commands or queries
for testing - there is more to it than a database?** I gave that some
thought as well, and it seems inevitable to introduce extra
abstractions, and make changes to the concepts discussed above; I'll
publish these tomorrow.  
  
*I've been entertaining lots of ideas on this topic lately, and I'm
curious to hear yours.*
