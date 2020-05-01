+++
title = "Glueing the browser and POS devices together "
slug = "2014-05-04-glueing-the-browser-and-pos-devices-together"
published = 2014-05-04T18:23:00+02:00
author = "Jef Claes"
tags = [ ".NET", "javascript", "Windows", "Browser",]
+++
I have been occupied building a modest Point of Sale system over these
last few weeks. Looking at implementing the client, there were two
constraints; it needed to run on Windows and it should be able to talk
to devices such as a ticket printer and a card reader.  
  
Although we could use any Windows client framework, we like building
things in the browser better for a number of reasons;
platform-independence, familiar user experience, JavaScript's
asynchronous programming model and its incredible rich ecosystem. Having
to talk to devices ruled out leveraging the browser to deliver our
application though - or didn't it?  
  
Most Windows client frameworks give you a browser component which can be
used to host web applications inside of your application. We used this
component to host our web application, which turned the hosting
application into not much more than a bridge between our web application
and the devices.  
  
This bridge processes commands sent by the browser (or the application
itself), and produces events which are returned to the browser. I ended
up not needing much code to implement this.  

  

I defined [two thread-safe
queues](http://msdn.microsoft.com/en-us/library/dd267312(v=vs.110).aspx)
- one to put commands on, and one to put events on. 

    private readonly BlockingCollection<ICommand> _commandQueue = 
        new BlockingCollection<ICommand>(); 
    private readonly BlockingCollection<IEvent> _eventQueue = 
        new BlockingCollection<IEvent>();

Then I start consuming the command queue in the background by turning it
into an observable and subscribing to it. Processing commands in the
background ensures that command processing never blocks the UI thread.  

    Task.Factory.StartNew(() =>
    {
        var processor = new CommandProcessor(_eventQueue);

        _commandQueue
            .GetConsumingEnumerable()
            .ToObservable()
            .Subscribe(processor.Execute);
    });

When a command is dequeued, the associated handler will be invoked. The
handler then does its work while raising events when appropriate.

    public class DoSomethingHandler : IHandle<DoSomething>
    {
        private readonly BlockingCollection<IEvent> _eventQueue;

        public SleepCommandHandler(BlockingCollection<IEvent> eventQueue) 
        {
            _eventQueue = eventQueue;
        }

        public void Execute(DoSomething cmd)
        {
            _eventQueue.Add(new DoingSomething());

            // do work

            _eventQueue.Add(new FinishedDoingSomething());
        }
    }

In the meanwhile the event queue is being processed in the background as
well - sending events to the browser as fast as they can be dequeued.

    Task.Factory.StartNew(() =>
    {
        _eventQueue
            .GetConsumingEnumerable()
            .ToObservable()
            .Subscribe(SendToBrowser);
    });

Sending events to the browser is done by invoking a script through the
browser control.

    private void SendToBrowser(IEvent @event)
    {
        object[] args = { string.Format("app.bus.send({0})", EventSerializer.Serialize(@event)) };

        if (WebBrowser.InvokeRequired)
        {
            WebBrowser.BeginInvoke((MethodInvoker)delegate
            {
                if (WebBrowser.Document != null)
                    WebBrowser.Document.InvokeScript("eval", args);
            });
        }
        else
        {
            if (WebBrowser.Document != null)
                WebBrowser.Document.InvokeScript("eval", args);
        }
    }

In the browser, we can now transparently subscribe to these events. As
an implementation detail on that side, we're using
[Postman](https://github.com/aaronpowell/Postman) for pub-sub in the
browser.  
  
With this, we've come full circle; commands come in, they get processed,
leading to events being produced, which eventually go out to the
browser.  
  
With this, we provide a consistent web experience for users and for
developers, while not having to jump through too much hoops to make it
work.  
  

[![](../images/thumbnails/2014-05-04-glueing-the-browser-and-pos-devices-together-BrowserIntegration.png)](../images/2014-05-04-glueing-the-browser-and-pos-devices-together-BrowserIntegration.png)

  
I also thought of hosting communication with the devices in a Windows
service while having that component expose its functionalities over HTTP
so that the browser could talk to a local endpoint instead of being
hosted in an application. While this is a valid alternative, it raised
some concerns towards deployment in our scenario (we can't push changes
towards these clients, they need to come get them). With the existing
set-up, I think even if we would like to change to such a model, it
wouldn't be that much trouble.  
  
If you've pieced together a similar solution, feel free to let me know
what I'm getting myself into.
