+++
title = "HTML5: Rebuilding the WebSockets Server prototype"
slug = "2011-01-09-html5-rebuilding-the-websockets-server-prototype"
published = 2011-01-09T18:45:00.002000+01:00
author = "Jef Claes"
tags = [ "HTML5",]
+++
Yesterday I [blogged on installing the Microsoft WebSockets
prototype](http://jclaes.blogspot.com/2011/01/html5-installing-microsoft-websockets.html)
with the Chat sample. The Chat sample needs a ChatService to broadcast
the messages to all active sessions. The source code of this ChatService
is not included in the package, that's why I decompiled the executable
using Reflector and rebuilt it.  
  
In this post you can find how to rebuild the Chat Websockets Server.  
  
**Class diagram**  
  
Once we are finished, our class diagram should look like this.  
  
[![](/post/images/thumbnails/2011-01-09-html5-rebuilding-the-websockets-server-prototype-classdiagram.PNG)](/post/images/2011-01-09-html5-rebuilding-the-websockets-server-prototype-classdiagram.PNG)  
**The server**  
  
The server will be hosted in a .NET 4.0 console application.  
  
**Dependencies**  
  
The server has a few dependencies which are not in the .NET 4.0
Framework:  

-   Microsoft.Runtime.Serialization.Json.dll
-   Microsoft.ServiceModel.WebSockets.dll
-   Microsoft.ServiceModel.Tcp.dll

  
You can find these assemblies in the %ProgramFiles%\\Microsoft SDKs\\WCF
WebSockets\\10.12.16\\bin folder. Make sure you have [installed the
Microsoft WebSockets
prototype](http://jclaes.blogspot.com/2011/01/html5-installing-microsoft-websockets.html).  
  
**The service**  
  
The Service class needs to inherit from the abstract WebSocketsService
class.  
  

    class Service : WebSocketsService 

  
The abstract WebSocketsService class has following properties and
methods.  
  

    public abstract class WebSocketsService : IWebSockets, IDisposable {

        protected WebSocketsService();

     

        protected WebHeaderCollection HttpRequestHeaders { get; }

        protected Uri HttpRequestUri { get; }

     

        protected void Close();

        public void Dispose();

        protected virtual void Dispose(bool disposing);

        protected virtual void OnClose(object sender, EventArgs e);

        protected virtual void OnError(object sender, EventArgs e);

        public virtual void OnMessage(JsonValue jsonValue);

        public virtual void OnOpen();

        public void Send(JsonValue jsonValue);

    }

  
The Service class needs to be decorated with a
[ServiceBehavior](http://msdn.microsoft.com/en-us/library/system.servicemodel.servicebehaviorattribute.aspx)
attribute. The InstanceContextMode property defines that a new instance
of the service needs to be created per session. The ConcurrencyMode
defines that the service instances are multithreaded. No synchronization
guarantees are made, so synchronization should be handled manually.  
  

    [ServiceBehavior(InstanceContextMode = InstanceContextMode.PerSession, 

                    ConcurrencyMode = ConcurrencyMode.Multiple)]

  
This class needs two static private fields:  

-   static int m\_globalId: This field holds a global id, which can be
    used to create a unique id for each new service instance.
-   static Sessions m\_sessions: This field contains an instance of the
    Sessions object, which is used to manage all active service
    instances.

  

    private static int m_globalId;

    private static Sessions m_sessions = new Sessions();

  
Next to the static private fields, this class also needs one private
instance field:  

-   int m\_id: This field holds an id used as a hash to identify the
    service instance.

    private int m_id = Interlocked.Increment(ref m_globalId);

  
In the constructor we add the new service instance to the collection of
already existing active service instances.  
  

    public Service() {

        if (!m_sessions.TryAdd(this)) {

            throw new InvalidOperationException("Can't add session.");

        }

    }

  
The GetHashCode() method returns the unique id that is used to identify
the service instance.  
  

    public override int GetHashCode() {

        return this.m_id;

    }

  
When a service is closed, we remove the service from the collection of
active service instances.  
  

    protected override void OnClose(object sender, EventArgs e) {            

        m_sessions.Remove(this);           

    }

  
When the service receives a message, we call the RelayMessage() method
on the Sessions instance.  

    public override void OnMessage(JsonValue jsonValue) {            

        m_sessions.RelayMessage(jsonValue);

    }

  
**ServiceCollection**  
  
This class is used to store a collection of services.  
  

    public class ServiceCollection<TService> : KeyedCollection<int, TService> where TService : class {

        protected override int GetKeyForItem(TService item) {

            return item.GetHashCode();

        }

    }  

  
**Sessions**  
  
This class is used to manage active service instances.  
  
The internal Sessions class has two private instance fields:  

-   ServiceCollection m\_innerCache: This fields holds a collection of
    service instances.
-   [ReaderWriterLockSlim](http://msdn.microsoft.com/en-us/library/system.threading.readerwriterlockslim.aspx)
    m\_thisLock: This lock is used throughout this class to
    thread-safely manage access to resources.

    private ServiceCollection<Service> m_innerCache = new ServiceCollection<Service>();

    private ReaderWriterLockSlim m_thisLock = new ReaderWriterLockSlim();

  
This class implements
[IDisposable](http://msdn.microsoft.com/en-us/library/system.idisposable.aspx).
In the Dispose() method the ReaderWriterLockSlim is disposed.  
  

    public void Dispose() {

        this.m_thisLock.Dispose();

    }

  
The TryAdd() method takes a service instance and tries to add the
instance to the private collection of service instances.  
  

    public bool TryAdd(Service entry) {

        bool flag;

        this.m_thisLock.EnterUpgradeableReadLock();

        try {

            if (this.m_innerCache.Contains(entry)) {

                flag = false;

            } else {

                this.m_thisLock.EnterWriteLock();

                try {

                    this.m_innerCache.Add(entry);

                    flag = true;

                } finally {

                    this.m_thisLock.ExitWriteLock();

                }

            }

        } finally {

            this.m_thisLock.ExitUpgradeableReadLock();

        }

        return flag;

    }

  
The RelayMessage() method takes a
[JsonValue](http://msdn.microsoft.com/en-us/library/system.json.jsonvalue(v=vs.95).aspx)
argument and makes all the services send it.  
  

    public void RelayMessage(JsonValue jsonValue) {

        List<Service> list = null;

        this.m_thisLock.EnterReadLock();

        try {

            foreach (Service service in this.m_innerCache) {

                try {

                    service.Send(jsonValue);

                    continue;

                } catch {

                    if (list == null) {

                        list = new List<Service>();

                    }

                    list.Add(service);

                    continue;

                }

            }

        } finally {

            this.m_thisLock.ExitReadLock();

        }

        if (list != null) {

            this.m_thisLock.EnterWriteLock();

            try {

                foreach (Service service2 in list) {

                    this.m_innerCache.Remove(service2);

                }

            } finally {

                this.m_thisLock.ExitWriteLock();

            }

        }

    }

  
The Remove() method takes a service instance and removes it
asynchronously from the private collection of service instances.  
  

    public void Remove(Service entry) {

        ThreadPool.QueueUserWorkItem(new WaitCallback(this.RemoveInternal), entry);

    }

     

    private void RemoveInternal(object state) {

        var item = state as Service;

        if (item != null) {

            this.m_thisLock.EnterWriteLock();

            try {

                this.m_innerCache.Remove(item);

            } finally {

                this.m_thisLock.ExitWriteLock();

            }

        }

    }

  
**Almost there**  
  
To finish the WebSockets Server we need to set up the WebSocketsHost in
Program.cs.  
  
Create a new instance of the WebSocketsHost&lt;Service&gt; class passing
in a baseaddress. Add an endpoint and finally open the host.  
  

    static void Main(string[] args) {

        var host = new WebSocketsHost<Service>(new Uri[] { new Uri(string.Format("ws://{0}:4502/chat", Environment.MachineName)) });

        host.AddWebSocketsEndpoint();

        host.Open();

     

        Console.WriteLine("Websocket server listening on " + host.Description.Endpoints[0].Address.Uri.AbsoluteUri);

        Console.WriteLine();

      

        using (ManualResetEvent mre = new ManualResetEvent(false)) {

            mre.WaitOne();

        }

        host.Close();

    }

  
That should be it. You can now run your own implementation of the Chat
WebSockets Server and use Visual Studio to step through the flow of the
server.  
  
<span style="font-weight: bold;">Download the source</span>  
  
You can [download the source
here](https://dl.dropbox.com/u/19698383/Blog/WebSocketsServer.rar).
