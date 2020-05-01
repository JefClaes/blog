+++
title = "Commands and events with JustSaying and AWS"
slug = "2016-09-18-commands-and-events-with-justsaying-and-aws"
published = 2016-09-18T20:52:00.003000+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2016/09/commands-and-events-with-justsaying-and.html"
+++
I've been looking into handing a bit of our messaging infrastructure
over to a managed alternative. Managing your own messaging
infrastructure that should be highly available is not always an
investment you want to make in this day and age. Going through the
documentation and relying on experiences from some people I trust, I
ended up looking at AWS and
[SNS](https://aws.amazon.com/sns/)/[SQS](https://aws.amazon.com/sqs/).  
  
Making the Github repository rounds, looking for inspiration, I stumbled
on [JustSaying](https://github.com/justeat/JustSaying): a library by the
people from JustEat implementing a message bus on top of AWS.  
  
I wanted to find two messaging patterns in this library:  
1. Command queuing. A common pattern in our components is to react to an event by making an HTTP request to an external partner. To improve reliability and throughput, we generally don't make that HTTP request in the projection itself, but rather drop a command onto a queue which will then be processed in parallel using a bounded amount of retries. When things do go wrong, we either retry  the messages by moving them from the error queue back to the input queue or we change the reaction and reset the projection checkpoint, sending the commands again.
2. Pub-sub. Another pattern used when there is a certain level of
familiarity between components, is to have a component publish
events. Other components can subscribe to these messages and have
them delivered to their own queues.`

Both these styles are supported by JustSaying.

In this example, I have two commands: BookFlight and CancelBooking, with
two related events: FlightWasBooked and BookingWasCancelled.

Since JustSaying requires messages to inherit from a base class, these
message definitions live on the outside, far from the domain. This
allows to decouple the domain from the outside contracts and to make
sure the events go out to the world in the format I want them to be.

```fsharp
type BookFlight() = inherit Message()
type CancelBooking() = inherit Message()
type FlightWasBooked() = inherit Message()
type BookingWasCancelled() = inherit Message()
```

To handle these messages, JustSaying requires you to implement the
IHandler interface.

```fsharp
type HandleBookFlight() =
  interface IHandler<BookFlight> with
      member this.Handle msg = printfn "Book flight"; true

type HandleCancelBooking() =
  interface IHandler<CancelBooking> with
      member this.Handle msg = printfn "Cancel booking"; true

type HandleFlightWasBooked() =
  interface IHandler<FlightWasBooked> with
      member this.Handle msg = printfn "Flight was booked"; true

type HandleBookingWasCancelled() =
  interface IHandler<BookingWasCancelled> with
      member this.Handle msg = printfn "Booking was cancelled"; true
```

Having this out of the way, we need to configure the bus (publishers and
subscribers).  
  
First of all, Amazon needs to know who we are and what we're allowed to
do.

```fsharp
let bus =
  CreateMeABus.DefaultClientFactory <- new Func<IAwsClientFactory>(
    fun () -> new DefaultAwsClientFactory(credentials) :> IAwsClientFactory)
```

We should define which region our infrastructure lives in.

```fsharp
CreateMeABus.InRegion("eu-west-1")
```

Now we can configure our command queue. Commands should be published
using an SQS publisher, directly dropping messages into the "Commands"
queue. A point-to-point subscriber will directly pull messages from the
"Commands" queue and hand them over to the command handlers.

```fsharp
.WithSqsMessagePublisher<BookFlight>(new Action<SqsWriteConfiguration>(fun x -> x.QueueName <- "Commands"))
.WithSqsMessagePublisher<CancelBooking>(new Action<SqsWriteConfiguration>(fun x -> x.QueueName <- "Commands"))
.WithSqsPointToPointSubscriber()
.IntoQueue("Commands")
.WithMessageHandler(new HandleBookFlight())
.WithMessageHandler(new HandleCancelBooking())
```

Events are not directly dropped to an SQS queue, but will be created as
an SNS topic. We can use SQS to subscribe to these topics and have them
delivered to an "Events" queue.

```fsharp
.WithSnsMessagePublisher<FlightWasBooked>()
.WithSnsMessagePublisher<BookingWasCancelled>()
.WithSqsTopicSubscriber()
.IntoQueue("Events")
.WithMessageHandler(new HandleFlightWasBooked())
.WithMessageHandler(new HandleBookingWasCancelled())
```

Once the bus has been created, we can start listening and publishing
messages.  
  
```fsharp
bus.StartListening()

bus.Publish(new BookFlight())
bus.Publish(new FlightWasBooked())
```

JustSaying will create two SNS topics and four SQS queues: two input
queues and two error queues.  

[![](/post/images/thumbnails/2016-09-18-commands-and-events-with-justsaying-and-aws-sns.PNG)](/post/images/2016-09-18-commands-and-events-with-justsaying-and-aws-sns.PNG)

[![](/post/images/thumbnails/2016-09-18-commands-and-events-with-justsaying-and-aws-sqs.PNG)](/post/images/2016-09-18-commands-and-events-with-justsaying-and-aws-sqs.PNG)

Those topic and queue names are not that descriptive once you introduce
multiple components and might cause names to collide. JustSaying allows
you to define a custom naming strategy. I've settled on a strategy that
is based on the message type and prefixed with the component name. This
has the added advantage that each message type now goes into its own
queue.  

```fsharp
type ComponentNamingStrategy () =
  interface INamingStrategy with
    member this.GetQueueName (sqsConfig, messageType) =
      "component_" + messageType.ToLower()
    member this.GetTopicName (topicName, messageType) =
      "component_" + messageType.ToLower()

.WithNamingStrategy(new Func<INamingStrategy>(fun _ -> new ComponentNamingStrategy() :> INamingStrategy))
```

[![](/post/images/thumbnails/2016-09-18-commands-and-events-with-justsaying-and-aws-sqsnamingstrategy.PNG)](/post/images/2016-09-18-commands-and-events-with-justsaying-and-aws-sqsnamingstrategy.PNG)
 
This whole experiment has had a scary low learning curve (maybe a bit
too low). While I'm still in the assess-phase, I'm fairly optimistic
that running on top of SNS/SQS might take away some of our operational
burden. Going over the JustSaying API and code base, it's quite
opinionated and there are things I might have approached differently.
Some features I'd like to see, like the library providing a message
envelope as a first-class citizen (a base message class is something
I've regretted in the past) is being worked on, so I'm keeping my eye on
those. Since I'm only using command queuing at the moment, I should be
pretty safe from future breaking changes to the message format and such.
