+++
title = "Building a live dashboard with some knockout"
slug = "2014-03-16-building-a-live-dashboard-with-some-knockout"
published = 2014-03-16T21:23:00.001000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET", "HTML", "javascript", "HTML5",]
+++
Last week, we added a dashboard to our back office application that
shows some actionable data about what's going on in our system. Although
we have infrastructure in place to push changes to the browser, it
seemed more reasonable to have the browser fetch fresh data every few
minutes.  
  
We split the dashboard up in a few functional cohesive widgets. On the
server, we built a view-optimized read model for each widget. On the
client, we wrote a generic view model that would fetch the raw read
models periodically.

    var ajaxWidgetModel = function (options) {
        var self = this;

        self.data = ko.observable();
        self.tick = function () {
            $.get(options.url, function (data) {
                self.data(ko.mapping.fromJS(data));
            });
        };

        self.tick();
        setInterval(self.tick, options.interval);
    };

We then used [knockout.js](http://knockoutjs.com/index.html) to bind the
view models to the widgets.

    ko.applyBindings(
        new ajaxWidgetModel({ url: "/api/dashboard/tickets", interval: 30000 }), 
        document.getElementById('widget_tickets'));

    <div class="widget-title">
        <h5>Tickets</h5>
    </div>
    <div class="widget-content" id="widget_tickets" data-bind="with: data">
        <table class="table">
            ...
        </table>
    </div>

The [with
data-binding](http://knockoutjs.com/documentation/with-binding.html)
ensures that the content container only gets shown when the read model
data has been fetched from the server.  
  
Building dumb view-optimized read models on the server, binding them to
a widget with one line of code, and some templating, allowed us to
quickly build a live dashboard in a straightforward fashion.
