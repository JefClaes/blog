+++
title = "Modeling the four-eye principle"
slug = "2013-04-21-modeling-the-four-eye-principle"
published = 2013-04-21T19:48:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "Ramblings",]
+++
Working in a financial domain over the last year, it was only a matter
of time before I would be confronted with one of the variations of [the
two-man rule](http://en.wikipedia.org/wiki/Two-man_rule): the four-eye
principle. Satisfying the principle is simple enough; an extra pair of
eyes needs to approve of requested changes before they're applied to the
system. This measure should prevent mistakes such as a user nuking North
Korea by accident, or transferring all corporate funds to a personal
off-shore bank account. In practice all you need is an accomplice.  
  
Although I have seen artifacts of this concept, this is the first time I
actively had to model it myself. Since I looked online for inspiration,
but returned empty handed, I'm documenting my findings here.  
  
I started out modeling the concept directly on the relevant entities,
but it was obvious really soon that this was going nowhere. The solution
headed in the wrong direction from the get go: copying records, dirty
tracking, a bunch of possible states, resulting in complex transitions,
and the need for an audit log. I couldn't even address these concerns
without them bleeding into other layers such as queries and
repositories. This design also failed to cover one edge scenario where
we don't need an entity at all.  
  
Returning home, I gave it another shot, but this time I modeled the
principle as a separate concept, not touching any existing entities. A
user hands in a request, which will be persisted, and will just sit
there until a supervisor approves or declines it. If it's accepted, the
request state gets updated, and all request handlers are invoked. It's
the request handlers that are responsible for applying the requested
change(s) to the system. Before the request handlers are invoked, no
existing entities are touched.  
  
Modeling the concept this way also leans closer to reality. You want to
keep your core system as clean and simple as possible, to avoid
confusion and mistakes where you can. If we would go back in time twenty
years, the requests would also have lived in a separate drawer.  
  
Here's some of my tinkering trying to support this concept.  
  
A request is actually a template. It will always contain the current
state, and some meta data concerning previous state transitions, but the
actual content is generic. When a supervisor accepts or declines a
request, a guard makes sure the user that made the original request, is
not the one doing the supervision. Other guards make sure the status
transition makes sense; you need to make a new request once it has been
supervised. When the request is accepted, a domain event gets raised.

    public class Request
    {
        public Request(Requested requested, IRequestContent content)
        {
            Guard.ForEmpty(requested, "requested");
            Guard.ForEmpty(content, "content");

            Id = Guid.NewGuid();

            Requested = requested;
            Content = content;
            Status = Status.Waiting;
        }

        public Guid Id { get; private set; }

        public Requested Requested { get; private set; }

        public Supervised Supervised { get; private set; }

        public IRequestContent Content { get; private set; }

        public Status Status { get; private set; }

        public void Accept(Supervised supervised)
        {         
            ChangeStatus(Status.Accepted, supervised);

            DomainEvents.Raise(new RequestAcceptedEvent() { RequestId = Id });
        }

        public void Decline(Supervised supervised)
        {           
            ChangeStatus(Status.Declined, supervised);            
        }

        private void ChangeStatus(Status status, Supervised supervised)
        {
            Guard.ForEmpty(supervised, "supervised");
            Guard.SupervisingUserBeingTheRequestingUser(Requested.By, supervised.By);

            if (Status != Status.Waiting)
                throw new InvalidOperationException(
                    "This request is already accepted or declined.");
            if (status == Status.Waiting)
                throw new InvalidOperationException(
                    "The status shouldn't be changed to Waiting after creation.");            

            Status = status;
            Supervised = supervised;
        }

        public override bool Equals(object obj)
        {
            if (obj == null || GetType() != obj.GetType())
                return false;

            var other = obj as Request;

            return Id == other.Id;
        }

        public override int GetHashCode()
        {
            return this.Id.GetHashCode();
        }
    }  

An event handler listens for the request accepted event, and uses the
content's type to make a generic type, which is then used to search the
container for relevant request handlers. Since our type system isn't
aware of our specific types - request handlers and request content are
both objects at this point, I sprinkle some dynamic on top, and rely on
the DLR to invoke the correct method. I think drawing outside the static
lines here helps keeping things simple; it's definitely nicer to read
than its counterpart, which needs to rely on reflection.

    public interface IRequestHandler<TRequestContent>
    {
        void OnAccepted(TRequestContent requestContent);
    }

    public class RequestAcceptedEventHandler : IEventHandler<RequestAcceptedEvent>
    {
        private readonly IKernel _kernel;
        private readonly IRequestRepository _requestRepository;

        public RequestAcceptedEventHandler(IKernel kernel, IRequestRepository requestRepository)
        {
            _kernel = kernel;
            _requestRepository = requestRepository;
        }

        public void Handle(RequestAcceptedEvent @event)
        {
            var request = _requestRepository.GetById(@event.RequestId);

            var requestHandlerType = 
                typeof(IRequestHandler<>)
                    .MakeGenericType(request.Content.GetType());
            foreach (var requestHandler in _kernel.GetAll(requestHandlerType))
                ((dynamic)requestHandler).OnAccepted((dynamic)request.Content);
        }
    }

Now that we have this in place, a scenario where a user requests to have
a missile launched, and a supervisor approves of this request, could
look like this.

    static void Main(string[] args)
    {
        var repository = kernel.Get<IRequestRepository>();
        
        var launchMissileRequest = new Request(
            new Requested(new User("MiniMe")),
            new LaunchMissileRequestContent("V-2", "The Ozone Layer"));
        
        repository.Add(launchMissileRequest);

        ListRepositoryContent(repository);
        
        var request = repository.GetById(launchMissileRequest.Id);
        
        request.Accept(new Supervised(new User("DrEvil")));

        ListRepositoryContent(repository);

        Console.ReadLine();
    }

    public class LaunchMissileRequestHandler : IRequestHandler<LaunchMissileRequestContent>
    {
        public void OnAccepted(LaunchMissileRequestContent requestContent)
        {    
            Console.WriteLine(string.Format("Launching {0} to {1}!!",
                requestContent.MissileName, requestContent.Destination));
        }
    }

    public class LaunchMissileRequestContent : IRequestContent
    {
        public LaunchMissileRequestContent(string missileName, string destination)
        {
            Guard.ForEmpty(missileName, "missile name");
            Guard.ForEmpty(destination, "destination");

            MissileName = missileName;
            Destination = destination;
        }

        public string MissileName { get; set; }

        public string Destination { get; set; }

        public string Summary
        {
            get { return string.Format("Launch {0} to {1}.", MissileName, Destination); }
        }
    }

This will result in the following being outputted to the console.

    -----------------------------------------
    Id: dcd6eaba-1a3e-4d81-82f4-4b2938911e7e
    Status: Waiting
    Summary: Launch V-2 to The Ozone Layer.
    -----------------------------------------
    Launching V-2 to The Ozone Layer!!
    -----------------------------------------
    Id: dcd6eaba-1a3e-4d81-82f4-4b2938911e7e
    Status: Accepted
    Summary: Launch V-2 to The Ozone Layer.
    -----------------------------------------

**Fully exposed**  
**  
**It's rare to see people share how they go at modeling real-life
problems - money and withdrawing funds from an account don't count. And
I get it; you're fully exposed; there is more than one way to skin a
cat; history and context is lost in translation; and the devil is in the
details. It's a shame though; there is no technology or methodology that
will save you when you get these things catastrophically wrong.
