+++
title = "Viewmodel extractors in ASP.NET MVC"
slug = "2011-10-17-viewmodel-extractors-in-asp-net-mvc"
published = 2011-10-17T20:24:00+02:00
author = "Jef Claes"
tags = [ "ASP.NET",]
+++
Last week, I wrote something on [assembling viewmodels in ASP.NET
MVC](http://jclaes.blogspot.com/2011/10/viewmodel-assemblers-in-aspnet-mvc.html).
In that post, I said it would be nice to have a layer between my
controller and my domain services that would assemble viewmodels for me.
This would work one-way. In the other direction - from controller to
domain services - I would just take a piece of my composite viewmodel
and pass that directly to my domain services.  
  
Well, that last part didn't really work out eventually. I found it hard
to find real-world scenarios where I could just pick a piece of my
viewmodel and directly pass it to the domain services.  
  
I was in need of something that could extract my domain models from my
dumb viewmodels. I really didn't want this logic to be a fixed part of
my viewmodel, nor did I want to make helper classes for these utility
methods. Looking for a place to put this, I thought of a set of
extension methods that pulls out every useful domain model per
viewmodel.  

    public static class AddEntryViewModelExtractors

    {

        public static Entry ExtractEntry(this AddEntryViewModel addEntryViewModel) 

        {

            var entry = new Entry();

     

            entry.Activity = new Activity();

            entry.Activity.Name = addEntryViewModel.ActivityName;            

            entry.Meta = addEntryViewModel.Meta;

     

            return entry;

        }

    }

This makes it possible to do something like this in my controller.  
  

    public ActionResult Add(AddEntryViewModel addEntryViewModel)

    {

        if (ModelState.IsValid)

        {

            _entryService.AddEntry(addEntryViewModel.ExtractEntry());

     

            return RedirectToAction("Index", "Home");

        }

        else

        {

            return View(addEntryViewModel);

        }

    }

  
So far, I'm liking this approach, pushing code away from the controller,
helping me to keep my controllers as lean as possible. I also enjoy that
it's trivial to test these extractor methods.  
  
Oh btw, I had a chance to look at AutoMapper, but I haven't decided yet
whether I find it helpful or not. I hardly came across scenarios where
simple mappings were sufficient.  
  
As always, I welcome your feedback and thoughts!
