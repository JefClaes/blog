+++
title = "jQuery-validate error messages in Twitter bootstrap tooltips"
slug = "2012-11-11-jquery-validate-error-messages-in-twitter-bootstrap-tooltips"
published = 2012-11-11T20:30:00.001000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "MVC", "ASP.NET MVC", "Browsers", "jQuery",]
+++
At work, we're using the combination of ASP.NET MVC3, jQuery,
jQuery-validate, [knockout](http://knockoutjs.com/) and [Twitter
Bootstrap](http://twitter.github.com/bootstrap/) on one of our projects.
Having postponed looking at the aesthetics of the client-side validation
for too long, we eventually found ourselves unsatisfied with the default
error labels. Wanting to save on space, we're experimenting with the
error messages being shown in a [Twitter Bootstrap
tooltip](http://twitter.github.com/bootstrap/javascript.html#tooltips).
After poking around for some while, I came up with something
satisfactory.  
  
In this example, I have a bootstrapped form that looks like this.

    @using (Html.BeginForm("ChangePassword", "Account", FormMethod.Post, new { @class = "form-horizontal"})) {

        <div class="control-group">
            <label class="control-label">Old password</label>
            <div class="controls">
                @Html.PasswordFor(m => m.OldPassword)                            
            </div>       
        </div>
        <div class="control-group">
            <label class="control-label">New password</label>
            <div class="controls">
                @Html.PasswordFor(m => m.NewPassword)                
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Confirm password</label>
            <div class="controls">
                @Html.PasswordFor(m => m.ConfirmPassword)                
            </div>                            
        </div>  
        <div class="control-group">
            <div class="controls">
                <button type="submit" class="btn btn-primary">Change password</button>
            </div>
        </div>
    }

To make the error messages show up in tooltips on the input controls, I
eventually ended up with the snippet below.

    $.validator.setDefaults({
        showErrors: function (errorMap, errorList) {
            this.defaultShowErrors();                            

            // destroy tooltips on valid elements                              
            $("." + this.settings.validClass)                    
                .tooltip("destroy");            

            // add/update tooltips 
            for (var i = 0; i < errorList.length; i++) {
                var error = errorList[i];
                             
                $("#" + error.element.id)
                    .tooltip({ trigger: "focus" })
                    .attr("data-original-title", error.message)                
            }
        }
    });

I'm setting a custom
[showErrors](http://docs.jquery.com/Plugins/Validation/Validator/showErrors)
function to extend the behaviour of the jQuery validator. I don't want
to lose the default behaviour (highlighting etc), so I start with
invoking the default showErrors function, to then destroy the tooltip on
all valid input elements and to finally add or update the tooltip and
its title on all invalid input elements. The errorList argument holds
all the information I need for this; an array of invalid elements and
their corresponding error messages.

    [Object, Object]
    > 0: Object
    >> element: <input>
    >> message: "The Current password field is required."
    > 1: Object
    >> element: <input>
    >> message: "The New password field is required."
    > length: 2

The end result looks like this.  
  

[![](../images/thumbnails/2012-11-11-jquery-validate-error-messages-in-twitter-bootstrap-tooltips-ChangePasswordValidation.png)](../images/2012-11-11-jquery-validate-error-messages-in-twitter-bootstrap-tooltips-ChangePasswordValidation.png)
