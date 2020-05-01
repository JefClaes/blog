+++
title = "Self-contained commands with dependencies "
slug = "2013-01-13-self-contained-commands-with-dependencies"
published = 2013-01-13T18:17:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET",]
+++
*Also read: [separating command data from logic and sending it on a
bus](http://www.jefclaes.be/2013/01/separating-command-data-from-logic-and.html)*  
  
In October I looked at [an architecture that limits abstractions to
solely commands and
queries](http://www.jefclaes.be/2012/10/commands-queries-and-testing.html). In
that post, I had some infrastructure that looked like this.

    public abstract class Command
    {
        public abstract void Execute();
    }

    public abstract class Query<T>
    {
        public abstract T Execute();
    }

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

Commands and queries are both accompanied by their specific handler. In
this example, the handler does nothing but invoking the command or
query. In reality, you want your handlers to do a little more. For
example: provide the commands and queries with a context to work with,
add logging, handle your unit of work and all of that good stuff.  
  
Let's look at the infrastructure, and particularly the handlers of a
project that uses RavenDB to store its data.

    public abstract class Command
    {
        public IDocumentSession Session { get; set; }

        public abstract void Execute();           
    }

    public abstract class Query<T>
    {
        public IDocumentSession Session { get; set; }

        public abstract T Execute();
    }

    public class CommandHandler : ICommandHandler
    {
        public void Execute(Command command)
        {            
            var store = DocumentStore.Get();
            using (var session = store.OpenSession())
            {
                command.Session = session;
                command.Execute();

                session.SaveChanges();
            }
        }
    }
        
    public class QueryHandler : IQueryHandler
    {    
        public T Execute<T>(Query<T> query)
        {
            var store = DocumentStore.Get();
            using (var session = store.OpenSession())
            {
                query.Session = session;

                return query.Execute();
            }
        }
    }

The handlers take care of creating and managing the session, but also
provide the commands and queries with a reference to the session.  
  
An actual command could look like this.

    public class ConfirmOrderCommand : Command
    {
        private Guid _token;

        public ConfirmOrderCommand(Guid token)
        {
            _token = token;
        }

        public override void Execute()
        {
            var order = Session.Query<Documents.Order>().Where(x => x.Token == _token).First();

            order.ChangeStatus(Documents.Status.Confirmed);
        }
    }

I really like this style of command and queries; very little ceremony.
The downside though, is that you can't use constructor dependency
injection. [Like discussed in this
post](http://www.jefclaes.be/2012/10/commands-with-dependencies.html),
you could split your classes in two parts: the handler and the data, and
you would solve that problem.  
  
I wasn't that keen on that approach. Also, now that I'm so accustomed to
having fast in-memory integration tests with RavenDB, it's exceptional
that I have the need to inject dependencies. I worked out an alternative
which allows me to inject dependencies without having to put my data
somewhere else.  
  
Instead of injecting the dependencies through the constructor, we're
going to use an Inject method. This is a convention; there is no
interface that enforces this. Returning to our ConfirmOrderCommand,
we'll add support for creating a new folder on the file system.

    public class ConfirmOrderCommand : Command
    {
        private IFileSystem _fileSystem;

        private Guid _token;

        public ConfirmOrderCommand(Guid token)
        {
            _token = token;
        }

        public override void Execute()
        {    
            var order = Session.Query<Documents.Order>().Where(x => x.Token == _token).First();
            
            _fileSystem.CreateDirectory(Path.Combine("D:\", order.Customer.Id));

            order.ChangeStatus(Documents.Status.Confirmed);
        }
        
        public void Inject(IFileSystem fileSystem) 
        {
            _fileSystem = fileSystem;
        }
    }

We can now amplify the commandhandler to automatically resolve and
inject the dependencies into our commands. The handler uses reflection
to look for a method named Inject on the type. If this method exists, it
will inspect the method for its expected arguments and try to resolve
those, to finally invoke the Inject method with its resolved arguments. 

    public class CommandHandler : ICommandHandler
    {
        private IKernel _kernel;

        public CommandHandler() { }

        public CommandHandler(IKernel kernel)
        {
            _kernel = kernel;
        }

        public void Execute(Command command)
        {
            if (_kernel != null)
                ResolveDependenciesIfNeeded(command);
                
            var store = DocumentStore.Get();
            using (var session = store.OpenSession())
            {
                command.Session = session;
                command.Execute();

                session.SaveChanges();
            }
        }

        private void ResolveDependenciesIfNeeded(Command command)
        {
            var method = command.GetType().GetMethod("Inject");
            if (method != null)
            {
                var parameters = method.GetParameters();
                var parameterInstances = new List<object>();

                foreach (var parameter in parameters)
                {
                    var type = parameter.ParameterType;
                    var instance = _kernel.Get(type);

                    parameterInstances.Add(instance);
                }

                method.Invoke(command, parameterInstances.ToArray());
            }
        }
    }

Consumers now don't have to care about the dependencies; they just have
to be registered in the container. In the tests however, we can now
explicitly inject mocks or stubs, and take advantage of having
discoverable dependencies though the Inject convention.

    [TestClass]
    public class When_confirming_an_order
    {
        private Mock<IFileSystem> _fileSystem;

        [TestInitialize]
        public void When()
        {
            DocumentStore.InitializeEmbedded();

            var cmd = new ConfirmOrderCommand("_token_");
            
            // Inject mock
            _fileSystem = new Mock<IFileSystem>();    
            cmd.Inject(_fileSystem.Object);

            new CommandHandler().Execute(cmd);
        }

        [TestMethod]
        public void the_status_is_changed_to_confirmed()
        {
            ...
        }
        
        [TestMethod]
        public void a_new_folder_is_created()
        {
            _fileSystem.Verify(...);
        }
    }

Although I haven't really gone the distance with this implementation - I
only have one command that has extra dependencies, I find this technique
showing lots of promise. You get the leanness of self-contained commands
and queries, while you still allow discoverable dependency injection by
convention, supported by a tiny bit of infrastructure in the handlers.  
  
*I'd like to hear your opinion.*
