+++
title = "Commands with dependencies"
slug = "2012-10-15-commands-with-dependencies"
published = 2012-10-15T16:57:00.001000+02:00
author = "Jef Claes"
tags = [ "ASP.NET MVC", ".NET", "Refactoring", "DDD",]
+++
*Also read: [Separating command data from logic and sending it on a
bus](http://www.jefclaes.be/2013/01/separating-command-data-from-logic-and.html)*  
  
Yesterday I wrote about an architecture which limits abstractions [by
solely introducing commands and
queries](http://www.jefclaes.be/2012/10/commands-queries-and-testing.html).
I shared a dead simple variation of this pattern, the advantages I
experienced, and how I could still unit test the controller if I wanted
to.  
At the end of that post I wondered how I would be able to test commands
in isolation; suppose the implementation doesn't use a database this
time, but a hairy, too low-level, third party webservice.  
  
Right now, the input arguments are inserted via the constructor, but
this leaves no room to inject dependencies. That is, if we don't want to
do awkward stuff with our Dependency Injection framework, and don't want
to resort to property- or method injection.  

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

One way to enable injecting dependencies could be to separate the
command in two parts; the handler, and the data.  

    public interface ICommandHandler<in TCommandData> 
    {
        void Execute(TCommandData commandData);
    }

Now we could rewrite the WithdrawAmountCommand. One class contains and
verifies the input data...  

    public class WithdrawAmountCommandData
    {
        public WithdrawAmountCommandData(string username, int amount)
        {
            if (string.IsNullOrEmpty(username))
                throw new NullReferenceException("username");

            Username = username;
            Amount = amount;
        }

        public string Username { get; private set; }

        public int Amount { get; private set; }
    }

...while the second class actually acts on the data.  

    public class WithdrawAmountCommandHandler : ICommandHandler<WithdrawAmountCommandData>
    {
        private readonly IAccountWebservice _accountWebservice;

        public WithdrawAmountCommandHandler(
            IAccountWebservice accountWebservice)
        {
            _accountWebservice = accountWebservice;
        }

        public void Execute(WithdrawAmountCommandData data)
        {
            _accountWebservice.Invoke(data.Username, data.Amount);
        }
    }

Testing commands in isolation is now straight-forward.  

    [TestMethod()]
    public void Execute_should_invoke_webservice_with_correct_arguments()
    {
        var accountWebService = new Mock<IAccountWebservice>();

        var command = new WithdrawAmountCommandHandler(accountWebService.Object); 
        command.Execute(new WithdrawAmountCommandData("JefClaes", 25));

        accountWebService.Verify(aws => aws.Invoke("JefClaes", 25));
    }

Don't forget that the controller also needs to accommodate this
change.  

    public class HomeController : Controller
    {
        private readonly IQueryHandler _qryHandler;
        private readonly ICommandHandler<WithdrawAmountCommandData> _withdrawAmountCommandHandler; 

        public HomeController()
        {
            _qryHandler = new QueryHandler();
            _withdrawAmountCommandHandler = new WithdrawAmountCommandHandler(new AccountWebservice());
        }

        public HomeController(
            IQueryHandler qryHandler,
            ICommandHandler<WithdrawAmountCommandData> withdrawAmountCommandHandler)
        {
            _qryHandler = qryHandler;
            _withdrawAmountCommandHandler = withdrawAmountCommandHandler;
        }

        [HttpPost]
        public ActionResult Foo(string user)
        {
            _withdrawAmountCommandHandler.Execute(new WithdrawAmountCommandData(user, 25));

            var totalAmount = _qryHandler.Execute<int>(new TotalAmountQuery(user));

            if (totalAmount < 0)
                return RedirectToAction("Warning");

            return RedirectToAction("Index");
        }
    }

I'm not all that happy with how this approach will bloat my controller
in the future to be honest. To smooth out this friction, I could - like
in the previous post - introduce a dispatcher, which serves as an
intermediary for the commandhandlers.  
  
Integration testing wasn't an option in this scenario, so I had to
introduce some extra abstractions just to facilitate unit testing.
Although this particular variation still holds lots of advantages I
talked about in my previous post, there's already a lot more boilerplate
and some more complexity.  
  
*I'm going to give this topic some more thought. Care to share yours?*
