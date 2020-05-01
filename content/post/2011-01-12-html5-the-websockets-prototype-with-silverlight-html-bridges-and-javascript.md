+++
title = "HTML5: The WebSockets prototype with Silverlight, HTML Bridges and JavaScript"
slug = "2011-01-12-html5-the-websockets-prototype-with-silverlight-html-bridges-and-javascript"
published = 2011-01-12T19:00:00.001000+01:00
author = "Jef Claes"
tags = [ "HTML5",]
+++
Last weekend, I blogged on [installing the WebSockets
prototype](http://jclaes.blogspot.com/2011/01/html5-installing-microsoft-websockets.html)
and [rebuilding the WebSockets chat
server](http://jclaes.blogspot.com/2011/01/html5-rebuilding-websockets-server.html).
In this post I will try to decompose the client-side chat sample to get
a better feel of what's going on in the browser.  
  
If you have installed the WebSockets prototype, you should be able to
browse to <http://localhost/chat/wsdemo.html> and stroll through the
internals with me.  
  
[![](../images/thumbnails/2011-01-12-html5-the-websockets-prototype-with-silverlight-html-bridges-and-javascript-chatsample.PNG)](../images/2011-01-12-html5-the-websockets-prototype-with-silverlight-html-bridges-and-javascript-chatsample.PNG)  
**Dependencies**  
  
The chat sample has four script dependencies:

-   jquery-1.4.2.min.js
-   json2.js
-   jquery.slws.js
-   h5utils.js

  
Because there is no sense in having a look inside a minified version of
jQuery, I'll only look at the three others: json2.js, jquery.slws.js and
h5utils.js.  
  
**Json2.js**  
  
This script creates a global JSON object, if it does not already exist,
containing two methods: stringify and parse.  
  
The
[stringify()](http://msdn.microsoft.com/en-us/library/cc836459(v=vs.85).aspx)
method turns a JavaScript value into a JSON text and, oh suprise, the
[parse()](http://msdn.microsoft.com/en-us/library/cc836466(v=vs.85).aspx)
method parses a JSON text to a JavaScript value.  
  
**jQuery.slws.js**  
  
This script is where the biggest part of the WebSockets prototype magic
happens. This script dynamically loads a Silverlight component into your
page. This Silverlight component exposes a bunch of methods through an
[HTML
Bridge](http://msdn.microsoft.com/en-us/library/cc645076(v=vs.95).aspx)
which can be used to talk to the WebSockets server.  
  

    jQuery(function ($) {

        if (!$.slws) $.slws = {};

        else if (typeof ($.slws) != "object") {

            throw new Error("Cannot create jQuery.slws namespace: it already exists and is not an object.");

        }

     

        $(document).ready(function () {

            var script = document.createElement("script");

            document.body.appendChild(script);

            script.src = 'js/Silverlight.js';

            var slhost = document.createElement("div");

            document.body.insertBefore(slhost, document.body.firstChild);     

            slhost.innerHTML =

            '<div align=center>' +

            '<object data="data:application/x-silverlight-2," type="application/x-silverlight-2" width="600" height="70">' +

                '<param name="source" value="ClientBin/Microsoft.ServiceModel.Websockets.xap"/>' +

                '<param name="onError" value="onSilverlightError" />' +

                '<param name="background" value="white" />' +

                '<param name="minRuntimeVersion" value="4.0.50401.0" />' +

                '<param name="autoUpgrade" value="true" />' +

                '<param name="onLoad" value="pluginLoaded" />' +

                '<a href="http://go.microsoft.com/fwlink/?LinkID=149156&v=4.0.50401.0" style="text-decoration:none">' +

                     '<img src="http://go.microsoft.com/fwlink/?LinkId=161376" alt="Get Microsoft Silverlight" style="border-style:none"/>' +

                '</a>' +

            '</object><iframe id="_sl_historyFrame" style="visibility:hidden;height:0px;width:0px;border:0px"></iframe></div>';

        });

     

        $.slws._callbacks = [];

     

        $.slws.ready = function (callback) {

            if (callback) {

                if ($.slws._loaded) {

                    callback();

                }

                else {

                    $.slws._callbacks.push(callback);

                }

            }

        }

    });

  
When the Silverlight component has finished loading, a global
WebSocketDraft object is created wrapping all the functions that are
exposed through the HTML Bridge of the Silverlight component.  
  

    function pluginLoaded(sender, args) {

        var slCtl = sender.getHost();

     

        window.WebSocketDraft = function (url) {

            this.slws = slCtl.Content.services.createObject("websocket");

            this.slws.Url = url;

            this.readyState = this.slws.ReadyState;

            var thisWs = this;

            this.slws.OnOpen = function (sender, args) {

                thisWs.readyState = thisWs.slws.ReadyState;

                if (thisWs.onopen) thisWs.onopen();

            };

            this.slws.OnMessage = function (sender, args) {

                if (String(args.Message).charAt(0) == '"' && thisWs.onmessage)

                    thisWs.onmessage({ data: String(args.Message) });

            };

            this.slws.OnClose = function (sender, args) {

                thisWs.readyState = thisWs.slws.ReadyState;

                if (thisWs.onclose) thisWs.onclose();

            };

            this.slws.Open();

        };

     

        window.WebSocketDraft.prototype.send = function (message) {

            if (message.charAt(0) != '"')

                message = '"' + message + '"';

            this.slws.Send(message);

        };

     

        window.WebSocketDraft.prototype.close = function() {

            this.slws.Close();

        };

     

        $.slws._loaded = true;

        for (c in $.slws._callbacks) {

            $.slws._callbacks[c]();

        }

    }

  
**H5utils**  
  
This script forces IE to acknowledge all new HTML5 elements. More on
this script can be found
[here](http://remysharp.com/2009/01/07/html5-enabling-script/).  
  
**Using the WebSockets**  
  
Now we have peeked at the script dependencies, we can have a look at the
actual usage of the WebSockets API.  
  
**Opening a WebSocket**  
  
Opening a connection to a WebSocket is very straightforward. Simply
create a new WebSocketDraft instance and pass in the endpoint to your
WebSockets server.  
  

    conn = new WebSocketDraft('ws://' + window.location.hostname + ':4502/chat');

  
**Handling events**  
  
Events that are handled in this sample are onopen, onmessage and
onclose.  
  

    conn.onopen = function () {

        state.className = 'success';

        state.innerHTML = 'Socket open';

    };

     

    conn.onmessage = function (event) {

        var message = JSON.parse(event.data);

        if (typeof message == 'string') {

            log.innerHTML = '<li class="them">' + 

                            message.replace(/[<>&]/g, function (m) { return entities[m]; }) + 

                            '</li>' + log.innerHTML;

        } else {

            connected.innerHTML = message;

        }

    };

     

    conn.onclose = function (event) {

        state.className = 'fail';

        state.innerHTML = 'Socket closed';

    };

  
**Sending a message**  
  
You can send a message using the send() method. Pass in a JSON text.  
  

    if (conn.readyState === 1) {

        conn.send(JSON.stringify(chat.value));    

    }

  
**Conclusions**  
  
The Silverlight solution is a creative hack which allows us to play
client-side with the WebSockets prototype until it is natively
implemented by IE.  
  
I am satisfied with the WebSocket API specifications, very simple to
use. What are your thoughts on the API?
