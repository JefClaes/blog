+++
title = "Customizing a knockout validation message"
slug = "2013-04-28-customizing-a-knockout-validation-message"
published = 2013-04-28T18:56:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC", "HTML", "javascript",]
+++
[Knockout
validation](https://github.com/ericmbarnard/Knockout-Validation) is a
plugin that allows you to extend observables with validation. If you're
familiar with jQuery validation, you will notice that most provided
validation rules are very similar.  
  
One of the validation rules available out-of-the-box is pattern
validation. By default the error message for violating this rule doesn't
mention the expected pattern. And in general, showing the expected
pattern probably isn't a good idea since your users will have no idea
what you're talking about. If you're building a back-end for devops
purposes, it might be more acceptable though.  
  
Instead of "Invalid.", I want my error message to be "I can't believe
the pattern doesn't match {pattern}.".  

    test('1. When the object is invalid, the error message contains our formatted message.', 
        function () {
            var testObj = ko.observable('').extend({ pattern: 'myPattern' });    
                
            testObj('something');
            
            equal(
                testObj.error, 
                'I can\'t believe the pattern doesn\'t match \'myPattern\'.', 
                'The formatted error message is correct.');    
        }
    );

    Expected: "I can't believe the pattern doesn't match 'myPattern'."
    Result:    "Invalid."
    Diff: "I can't believe the pattern doesn't match 'myPattern'." "Invalid." 

Digging a bit into the source, I found the function that formats the
error messages; it simply replaces {0} in the message with the params
value.

    formatMessage: function (message, params) {
        if (typeof (message) === 'function')
            return message(params);
        return message.replace(/\{0\}/gi, params);
    };

So to change the error message to have it include the pattern, we can
pass a pattern object which contains our message with the params
placeholder and the params value. 

    test('2. When the object is invalid, the error message contains our formatted message.', 
        function () {   
            var testObj = ko
                .observable('')
                .extend({ pattern: {
                    message: 'I can\'t believe the pattern doesn\'t match \'{0}\'.',
                    params: 'myPattern'
            }});                            
                    
            testObj('something');
            
            equal(
                testObj.error, 
                'I can\'t believe the pattern doesn\'t match \'myPattern\'.', 
                'The formatted error message is correct.');    
        }
    );

    The formatted error message is correct.
    Expected: "I can't believe the pattern doesn't match 'myPattern'."

This will make our test pass. It's not a great idea to repeat this in
each location though. Since the plugin exposes its rules, you can just
go in, modify the default message for the pattern rule, and see it
applied everywhere.

    test('3. When the objects are invalid, the error message contains our formatted message.', 
        function () {
            var testObj1 = ko.observable('').extend({ pattern: 'myPattern' });
            var testObj2 = ko.observable('').extend({ pattern: 'myPattern' });
                                                
            ko.validation.rules['pattern'].message = 
                'I can\'t believe the pattern doesn\'t match \'{0}\'.',    
            
            testObj1('something');
            testObj2('something');
            
            equal(
                testObj1.error, 
                'I can\'t believe the pattern doesn\'t match \'myPattern\'.', 
                'The formatted error message is correct for testObj1.');      
            equal(
                testObj2.error, 
                'I can\'t believe the pattern doesn\'t match \'myPattern\'.', 
                'The formatted error message is correct for testObj2.');      
        }
    );

    The formatted error message is correct.
    Expected: "I can't believe the pattern doesn't match 'myPattern'."
    The formatted error message is correct.
    Expected: "I can't believe the pattern doesn't match 'myPattern'."

I hope that even if you weren't interested in this exact scenario, this
post gave you an idea on how to go at customizing knockout validation
messages.
