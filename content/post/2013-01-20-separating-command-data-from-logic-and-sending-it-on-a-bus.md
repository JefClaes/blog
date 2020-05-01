+++
title = "Separating command data from logic and sending it on a bus"
slug = "2013-01-20-separating-command-data-from-logic-and-sending-it-on-a-bus"
published = 2013-01-20T22:03:00.002000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "Refactoring", "DDD", "NancyFx",]
+++
In [my first post on this
topic](http://www.jefclaes.be/2012/10/commands-queries-and-testing.html),
I started out with an attempt to limit abstractions to solely commands
and queries. Commands and queries were self-contained and could be
invoked by passing them to a context-providing generic handler. The
drawback of this approach was that it made constructor dependency
injection impossible. In a [next
post](http://www.jefclaes.be/2012/10/commands-with-dependencies.html), I
separated data from logic, but never got around to writing a dispatcher
that associates command data with their handlers. Last week, [I
revisited the first
approach](http://www.jefclaes.be/2013/01/self-contained-commands-with.html),
and added an unconventional implementation of injecting dependencies by
an Inject method convention.  
  
I still believe that last approach is very simple and works fine if
extra dependencies are exceptional. I do admit that it will make
architectural shoots harder to handle; everything is rather tightly
coupled. So let's look at an alternative architecture which pulls all
the bits apart, and should be better equipped to handle change.  
  
Let's first separate command data from logic.

    public class CreateSubscriptionCommand 
    {     
        public CreateSubscriptionCommand(string value, string category, string emailAddress)
        {
            Guard.StringIsNullOrEmpty(value, "value");
            Guard.StringIsNullOrEmpty(category, "category");
            Guard.StringIsNullOrEmpty(emailAddress, "emailAddress");

            Value = value;
            Category = category;
            EmailAddress = emailAddress;
        }

        public string Value { get; private set; }

        public string Category { get; private set; }

        public string EmailAddress { get; private set; }

        public override bool Equals(Object other)
        {
            if (other == null)
                return false;

            var otherCommand = other as CreateSubscriptionCommand;
            if (otherCommand == null)
                return false;

            return otherCommand.Value == Value && 
                otherCommand.Category == Category && 
                otherCommand.EmailAddress == EmailAddress;
        }    

        public override int GetHashCode()
        {
            return Value.GetHashCode() ^ 
                Category.GetHashCode() ^ 
                EmailAddress.GetHashCode();
        }
    }

The data is just a POCO. Notice the equality overrides; this comes in
handy when you're testing.  
  
The class that handles on the data needs to implement the
ICommandHandler interface.

    public class CreateSubscriptionCommandHandler 
        : ICommandHandler<CreateSubscriptionCommand>
    {    
        private IDocumentSession _session;

        public CreateSubscriptionCommandHandler(IDocumentSession session)
        {
            _session = session;
        }

        public void Handle(CreateSubscriptionCommand command)
        {
            var subscription = new Documents.Subscription(
                command.Value, command.Category, command.EmailAddress);

            _session.Store(subscription);    
        }
    }

Compared to the previous approach, we're now injecting the session
instead of having it handy as a property; that coupling is now
completely gone.  
  
Last thing left to do is create an interface that consumers can use to
send commands on: a bus.

    public class Bus : IBus
    {
        private readonly IKernel _kernel;
        private readonly IDocumentSession _session;

        public Bus(IKernel kernel, IDocumentSession session)
        {
            _kernel = kernel;
            _session = session;
        }

        public void ExecuteCommand<T>(T command) where T : class
        {
            var handler = _kernel.Get<ICommandHandler<T>>();

            handler.Handle(command);

            _session.SaveChanges();
        }
    }

The ExecuteCommand method dispatches data to the correct handler by
resolving it from the container, and also commits the unit of work.  
  
The consumer can execute commands like this.

    bus.ExecuteCommand(
        new CreateQueryCommand(queryValue, category, emailAddress));

With this approach having all the bits spread, we have a bit more work
gluing all the pieces together. The session is now known in the
container, and is request scoped. The commandhandlers are also all
registered in the container.

    protected override void ConfigureRequestContainer(IKernel container, NancyContext context)
    {        
            // you don't want to register them all individually
            container
                .Bind<ICommandHandler<CreateSubscriptionCommand>>()
                .To<CreateSubscriptionCommandHandler>();        
            // snip..
            container.Bind<IDocumentSession>()
                .ToMethod((ctx) => { 
                    return ctx.Kernel.Get<IDocumentStore>().OpenSession();    
                })
                .InSingletonScope();                          
    }

  
I think this approach might suit a lot of projects better if your
commands are dependency heavy.  
What I like most is that handling architectural shoots will be easier.
For example: right now, all behaviour is in my entities and in my
commands; the segregation of application services and domain services is
non-existent. And this works fine so far; I yet have to find a use case
where I would benefit from more separation. If that would change in the
future though, I can introduce abstractions, and concepts, without
breaking consumer code, and without having to do awkward stuff managing
the newly introduced dependencies.  
  
*As always, your thoughts are appreciated.*
