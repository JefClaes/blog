+++
title = "Persisting model state when using PRG"
slug = "2012-06-17-persisting-model-state-when-using-prg"
published = 2012-06-17T16:48:00+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", "ASP.NET MVC",]
+++
I've been working on an ASP.NET MVC application in which we frequently
apply the [Post/Redirect/Get
pattern](http://en.wikipedia.org/wiki/Post/Redirect/Get). One of the
direct consequences of applying this pattern is that you often want to
persist the model state across redirects, so that you don't lose
validation errors, or the values of input fields.  
  
To persist the model state across redirects, we can put
[TempData](http://msdn.microsoft.com/en-us/library/dd394711.aspx) to
work. The sole purpose of TempData is exactly this; persisting state
until the next request.  

    public ActionResult Index()
    {
        ViewData.Model = ...

        if (TempData.ContainsKey("ModelState"))
            ModelState.Merge((ModelStateDictionary)TempData["ModelState"]);

        return View();
    }

    [HttpPost]        
    public ActionResult Update(AddModel inputModel)
    {
        if (ModelState.IsValid)
            ...

        TempData["ModelState"] = ModelState;

        return RedirectToAction("Index");
    }

So this works, but I found it to be a bit too cumbersome. And so did
[Davy Brion](https://twitter.com/#!/davybrion), he introduced a clean
abstraction into the project, smoothing out some of the friction: making
use of action filter attributes, we were able to eliminate duplication
across controllers, leaving behind an AOP-ish taste.  
  
The SetTempDataModelStateAttribute stores the model state in the
TempData dictionary.  

    public class SetTempDataModelStateAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            base.OnActionExecuted(filterContext);         
            filterContext.Controller.TempData["ModelState"] = 
               filterContext.Controller.ViewData.ModelState;
        }
    }

While the RestoreModelStateFromTempDataAttribute restores it by pulling
it out of TempData again, when it exists.  

    public class RestoreModelStateFromTempDataAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);
            if (filterContext.Controller.TempData.ContainsKey("ModelState"))
            {
                filterContext.Controller.ViewData.ModelState.Merge(
                    (ModelStateDictionary)filterContext.Controller.TempData["ModelState"]);
            }
        }
    }

So when we apply these attributes to the example at the beginning of
this post, we end up with something like this.  

    [RestoreModelStateFromTempData]
    public ActionResult Index()
    {
        ViewData.Model = ...    

        return View();
    }

    [HttpPost]   
    [SetTempDataModelState]     
    public ActionResult Update(AddModel inputModel)
    {
        if (ModelState.IsValid)
            ...
        
        return RedirectToAction("Index");
    }

Very clean. I'm interested to hear how you handle these concerns when
using the PRG pattern.
