+++
title = "Sending commands from a knockout.js view model"
slug = "2014-03-23-sending-commands-from-a-knockout-js-view-model"
published = 2014-03-23T18:31:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "AJAX", "javascript", "ASPNET MVC",]
+++
While I got to use [angular.js](http://angularjs.org/) for a good while
last year, I found myself returning to
[knockout.js](http://knockoutjs.com/) for the current application I'm
working on. Where angular.js is a heavy, intrusive, opinionated, but
also very complete framework, knockout.js is a small and lightweight
library giving you not much more than a dynamic model binder. So instead
of blindly following the angular-way, I'll have to introduce my own set
of abstractions and plumbing again; I assume that I'll end up with a lot
less.  
  
Let's say that I have a view model for making a deposit.

    var DepositViewModel = function() {
        var self = this;

        self.account = ko.observable('');
        self.amount = ko.observable(0);

        self.depositEnabled = ko.computed(function() {
            return self.account() !== '' && self.amount() > 0;
        });
        
        self.deposit = function() {
            if (!self.depositEnabled()) {
                throw new Error('Deposit should be enabled.');
            }

            $.ajax({ 
                url: '/Commands/Deposit', 
                data: { account: self.account(), amount: self.amount() }, 
                success: function() { self.amount(0); }
                type: 'POST', 
                dataType: 'json' 
            });
        };
    };

    ko.applyBindings(new DepositViewModel());

Writing a test for this, it was obvious that I couldn't have my deposit
function make requests directly. An abstraction that has served me well
in the past, is a command executor. 

    CommandExecutor = function() {
        this.execute = function(command, success) { };
    };

We can have an implementation that handles each command individually, or
we can have it send requests to our server by convention. The
implementation below assumes that the name of our command has a
corresponding endpoint on the server. 

    CommandExecutor = function() {

        this.execute = function(command, success) {

            if (console) {
                console.log('Executing command..');
                console.log(command);
            }

            $.ajax({ 
                url: '/Commands/' + command.name, data: command.data, 
                success: success
                type: 'POST', dataType: 'json' 
            });

        };
    };

While angular.js has dependency management built in, we can get away by
injecting dependencies manually and a bit of bootstrapping - it's not
that I often have large dependency graphs in the browser, or that I care
much about the life cycles of my components.

    var DepositViewModel = function(dependencies) {
        var self = this;

        self.account = ko.observable('');
        self.amount = ko.observable(0);

        self.depositEnabled = ko.computed(function() {
            return self.account() !== '' && self.amount() > 0;
        });
        
        self.deposit = function() {
            if (!self.depositEnabled()) {
                throw new Error('Deposit should be enabled.');
            }

            var command = { 
                name: 'Deposit', 
                data: { account: self.account(), amount: self.amount() } };
            var callback = function() { self.amount(0); };
            dependencies.commandExecutor.execute(command, callback);
        };
    };

    ko.applyBindings(new DepositViewModel({ commandExecutor: new CommandExecutor() }));

See, very little magic required.  
  
Writing a test, we now only need to replace the command executor with an
implementation that will record commands instead of actually sending
them to the server.

    var CommandExecutorMock = function () {

        var commands = [];

        this.execute = function (command, success) {
            commands.push(command);
            success();
        };
        this.verifyCommandWasExecuted = function(command) {
            for (var i = 0; i < commands.length; i++) {
                if (JSON.stringify(commands[i]) === JSON.stringify(command)) {
                    return true;                        
                }
            }
            return false;
        };

    };

    describe("When a deposit is invoked", function () {

        var commandExecutor = new CommandExecutorMock();
        
        var model = new DepositViewModel({ commandExecutor: commandExecutor });
        model.account('MyAccount');
        model.amount(100);
        model.deposit();

        it("a deposit command is sent.", function() {
            var command = {
                name: 'Deposit', 
                data: { account: 'MyAccount', amount: 100 }
            };

            expect(commandExecutor.verifyCommandWasExecuted(command)).toBe(true);
        });  

    });

I did something similar for queries, and ended up with not that much
code, that didn't even take that long to write. I'm curious to see how
this application will evolve.
