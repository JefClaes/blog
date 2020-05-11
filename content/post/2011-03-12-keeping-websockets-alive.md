+++
title = "Keeping WebSockets alive"
slug = "2011-03-12-keeping-websockets-alive"
published = 2011-03-12T17:40:00.003000+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2011/03/keeping-websockets-alive.html"
+++
The problem with using stateful connections on an imperfect place as the
internet is that connections might drop. The server or an intermediary
can drop the connection due to an idle timeout. Even a temporary problem
at the server or a local network hiccup might kill your connection.  
  
If you aren't prepared to handle these scenarios, you will not be able
to fully rely on [WebSockets](http://websocket.org/).  
  
### A simple solution 
  
The simplest solution is checking every few seconds whether the
WebSocket is still opened. This might suffice in a good amount of
scenarios, but a lot of other scenarios require more stable
connectivity.  
  
```js
$(document).ready(function () {        
    setInterval(openWebSocket, 5000);
}

function openWebSocket(){
    if (websocket.readyState === undefined || websocket.readyState > 1) {
        ...
    }
}
```
  
### Keepalives
  
As mentioned before, the server or an intermediate might drop the
connection when the connection becomes idle. To prevent this, you could
make your server send keepalive messages at predefined intervals.  
  
I implemented this in the [HTML5 Labs WCF Server](https://jefclaes.be/2011/01/html5-rebuilding-websockets-server.html).  
  
```cs
[ServiceBehavior(InstanceContextMode = InstanceContextMode.PerSession, 
                 ConcurrencyMode = ConcurrencyMode.Multiple)]

public class CadSubscriptionService : WebSocketsService {
    private static KeepAliveBroadcaster _keepAliveBroadcaster;

    public CadSubscriptionService() {           
        if (_keepAliveBroadcaster == null) {
            _keepAliveBroadcaster = new KeepAliveBroadcaster();
        }
    }
 
    public override void OnOpen() {
        _keepAliveBroadcaster.AddService(this);

        base.OnOpen();
    }

    protected override void OnClose(object sender, EventArgs e) {
        _keepAliveBroadcaster.RemoveService(this);

        base.OnClose(sender, e);
    }     
}
```
  
The `KeepAliveBroadcaster` class maintains a list of connected sessions.
Using a [Timer](http://msdn.microsoft.com/en-us/library/system.threading.timer.aspx) it sends a message to each client every 15 seconds. This should stop the connection from dropping due to an idle timeout.  
  
```cs
public class KeepAliveBroadcaster {

    private List<WebSocketsService> _services;
    private Timer _timer;

    public KeepAliveBroadcaster() {
        _timer = new Timer((o) => {
            if (_services == null) {
                return;
            }

            lock (_services) {
                if (_services.Count > 0) {
                    foreach (var service in _services) {
                        service.Send("staying alive!");
                    }
                }
            }
        }, null, 100, 15000);              
    }

    public void AddService(WebSocketsService service) {
        if (_services == null) {
            _services = new List<WebSocketsService>();
        }

        lock (_services) {               
            _services.Add(service);
        }
    }

    public void RemoveService(WebSocketsService service) {
        lock (_services) {
            _services.Remove(service);
        }
    }
}
```

### Reopening ASAP  
  
Something you could also implement is reopening the connection as soon
as it closes.  
  
Retry opening the connection when the onclose event fires. Think about
limiting the number of retries, or you might end up with an infinite
loop.  
  
```js
    websocket.onclose = function (event) {            
        $('#status').html('Socket closed');    
        
        retryOpeningWebSocket();
    };


    function retryOpeningWebSocket(){
        if (retries < 2) {            
            setTimeout(openWebSocket, 1000);            
            retries++;
        }
    }
```

### Some afterthought  
  
Depending on what type of connectivity you require, these solutions
might not suffice. If you can't afford to lose a single message, you
might want to think about implementing queues at the client and server
to overcome a gap of connection loss. Maybe you even want to implement
some sort of acknowledge messaging. Something for a future post maybe!  