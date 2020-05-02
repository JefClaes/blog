+++
title = "Validating composite models with knockout validation"
slug = "2013-05-20-validating-composite-models-with-knockout-validation"
published = 2013-05-20T17:02:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2013/05/validating-composite-models-with.html"
+++
When you use [knockout
validation](https://github.com/Knockout-Contrib/Knockout-Validation) to
extend observables with validation rules, it will add a few functions to
these observables - the most important ones being; error and isValid.
You can use these functions to verify if any of the validation rules
were violated, and to extract an error message.  
  
To extract all of the error messages out of a composite model, you can
use a grouping function.

```js
function BookingModel() {      
    var self = this;
    
    self.contact = new ContactModel();
    self.departure = new DepartureModel();
    
    self.isValid = function() {
        return self.contact.isValid() && self.departure.isValid();
    };
    
    self.validate = function() {                           
        if (!self.isValid()) {
            var errors = ko.validation.group(self);                           
            errors.showAllMessages();
        
            return false;          
        }

        return true;
    };                    
}

function DepartureModel() {
    this.street = ko.observable('').extend({ required: true });
    this.houseNumber = ko.observable('').extend({ required: true });
    this.city = ko.observable('').extend({ required: true });
    this.time = ko.observable('').extend({ required: true });            
    
    this.isValid = function() {
        return 
            this.street.isValid() &&
            this.houseNumber.isValid() &&
            this.city.isValid() &&
            this.time.isValid();                
    };
}

function ContactModel() {
    this.firstName = ko.observable('').extend({ required: true });
    this.lastName = ko.observable('').extend({ required: true });
    this.phoneNumber = this.firstName = ko.observable('').extend({ required: true });
    this.email = ko.observable('').extend({ required: true });   

    this.isValid = function() {
        return 
            this.firstName.isValid() &&
            this.lastName.isValid() &&
            this.phoneNumber.isValid() &&
            this.email.isValid();                
    };    
}
```

This is what my first attempt looked like. A little later I discovered
that you can get rid of these boilerplate functions on the composite
model by applying the `validatedObservable` function instead.

```js
ko.applyBindings(ko.validatedObservable(new BookingModel()));

ko.validatedObservable = function (initialValue) {
    if (!exports.utils.isObject(initialValue)) { 
        return ko.observable(initialValue).extend({ validatable: true }); }

    var obsv = ko.observable(initialValue);
    obsv.errors = exports.group(initialValue);
    obsv.isValid = ko.computed(function () {
        return obsv.errors().length === 0;
    });

    return obsv;
};
```

The `validatedObservable` function will add an errors function to the
composite model which traverses the object graph and validates each
eligible property. The errors function also has a `showAllMessages`
function that will display an error message next to each invalid
element. The `isValid` function only asserts if there are any errors.

```js
function BookingModel() {      
    var self = this;
    
    self.contact = new ContactModel();
    self.departure = new DepartureModel();

    self.validate = function() {                           
        if (!self.isValid()) {                                         
            self.errors.showAllMessages();
        
            return false;          
        }

        return true;
    };             
}   

function DepartureModel() {
    this.street = ko.observable('').extend({ required: true });
    this.houseNumber = ko.observable('').extend({ required: true });
    this.city = ko.observable('').extend({ required: true });
    this.time = ko.observable('').extend({ required: true });            
}

function ContactModel() {
    this.firstName = ko.observable('').extend({ required: true });
    this.lastName = ko.observable('').extend({ required: true });
    this.phoneNumber = this.firstName = ko.observable('').extend({ required: true });
    this.email = ko.observable('').extend({ required: true });        
}
```

Removing that cruft results in less bulky, cheaper models.  
  
If you try this example, you will notice that the model appears to be
valid even though the validation rules are clearly violated. It took me
a few minutes of browsing the source to figure out why this was
happening. When you use the group functions to validate your model, they
will by default only look at first level properties. So if you have a
composite model, you need to modify the grouping validation
configuration, and set the deep property to true.

```js
ko.validation.init({ grouping : { deep: true, observable: true } });
```