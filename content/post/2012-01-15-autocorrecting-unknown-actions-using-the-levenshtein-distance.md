+++
title = "Autocorrecting unknown actions using the Levenshtein distance"
slug = "2012-01-15-autocorrecting-unknown-actions-using-the-levenshtein-distance"
published = 2012-01-15T16:04:00+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2012/01/autocorrecting-unknown-actions-using.html"
+++
This weekend I prototyped an idea I had earlier this week:
autocorrecting unknown actions in ASP.NET MVC.  
  
### Handling unknown actions  
  
To give you an example, let's say I have a Home controller with an
action named Kitten on it. If there is an incoming route for the Home
controller with Kitty (instead of Kitten) as the action name, the
controller will not be able to invoke any action method and instead will
call the `HandleUnknownAction` method.  
  
Here is the snippet from the ASP.NET MVC source.  

```csharp
protected override void ExecuteCore() {
    PossiblyLoadTempData();
    try {
        string actionName = RouteData.GetRequiredString("action");
        if (!ActionInvoker.InvokeAction(ControllerContext, actionName)) {
            HandleUnknownAction(actionName);
        }
    }
    finally {
        PossiblySaveTempData();
    }
}
```

The `HandleUnknownAction` is virtual, meaning we can override it in our
derived controller. The base implementation of the `HandleUnknownAction`
method does nothing more than throwing a `404 HttpException`.  

```csharp
protected virtual void HandleUnknownAction(string actionName) {
    throw new HttpException(404, String.Format(CultureInfo.CurrentCulture,
        MvcResources.Controller_UnknownAction, actionName, GetType().FullName));
}
```

So let's override the `HandleUnknownAction` method and try to autocorrect
the unknown action name. To be safe, we will only attempt to autocorrect
the action name when it's a GET HTTP request.  

```csharp
protected override void HandleUnknownAction(string actionName)
{
    if (!HttpContext.Request.HttpMethod.Equals("GET", StringComparison.OrdinalIgnoreCase))
        Throw404HttpException(actionName);
    
    TryToRedirectToAnActionNearby(actionName);           
}
```

### Listing all actions  
  
First we need a list of all available action names. I reflect on the
methods of the current controller and select the methods which are
public, can be invoked and are an instance method. Also the method
should return an `ActionResult`, not be decorated with the `HttpPost`
attribute and not have a special name. I'm pretty sure I'm missing a few
things here, but there seems to be no generic way to extract this
metadata from a controller. Places where these type of things are used
in the framework seem to be internal or non-public.  

```csharp
private IEnumerable<string> GetAllHttpGetActionNames()
{
    return GetType()
            .GetMethods(BindingFlags.InvokeMethod | 
                        BindingFlags.Public | 
                        BindingFlags.Instance)
            .Where(m => m.ReturnType == typeof(ActionResult) &&
                        !m.IsSpecialName &&
                        !m.GetCustomAttributes(true)
                            .Contains(typeof(HttpPostAttribute)))
            .Select(m => m.Name)
            .Distinct();
}
```

Once we have all these action names, we want to see how distant they are
from the unknown action name we are trying to autocorrect here. To
calculate this we can use the Levenshtein distance algorithm.  
  
### The Levenshtein distance  
  
The [Levenshtein
distance](http://en.wikipedia.org/wiki/Levenshtein_distance) is defined
by Wikipedia like this.  

> In information theory and computer science, the Levenshtein distance
> is a string metric for measuring the amount of difference between two
> sequences. The Levenshtein distance between two strings is defined as
> the minimum number of edits needed to transform one string into the
> other, with the allowable edit operations being insertion, deletion,
> or substitution of a single character. It is named after Vladimir
> Levenshtein, who considered this distance in 1965.

An implementation of this algorithm in C\# could look like this.  

```csharp
public static int CalculateDistance(string str1, string str2) 
{
    var matrix = new int[str1.Length + 1, str2.Length + 1];

    for (var i = 0; i <= str1.Length; i++)
        matrix[i, 0] = i;
    for (var j = 0; j <= str2.Length; j++)
        matrix[0, j] = j;

    for (var i = 1; i <= str1.Length; i++)
    {
        for (var j = 1; j <= str2.Length; j++)
        {
            var cost = str1[i - 1] == str2[j - 1] ? 0 : 1;

            matrix[i, j] = (new[]
            {
                matrix[i - 1, j] + 1, matrix[i, j - 1] + 1, matrix[i - 1, j - 1] + cost
            }).Min();

            if ((i > 1) && 
                (j > 1) && 
                (str1[i - 1] == str2[j - 2]) &&
                (str1[i - 2] == str2[j - 1]))
            {
                matrix[i, j] = Math.Min(matrix[i, j], matrix[i - 2, j - 2] + cost);
            }
        }
    }

    return matrix[str1.Length, str2.Length];
}        
```

This is a direct port from the [pseudocode found on Wikipedia](http://en.wikipedia.org/wiki/Levenshtein_distance#Computing_Levenshtein_distance). These tests might, probably a lot more than the implementation, help you understand what the Levenshtein algorithm calculates.  

```csharp
[TestMethod()]
public void Test_CalculateDistance_With_Two_Empty_String()
{           
    Assert.AreEqual(0, Levenshtein.CalculateDistance(string.Empty, string.Empty));
}   

[TestMethod()]
public void Test_CalculateDistance_With_Empty_First_String()
{         
    Assert.AreEqual(6, Levenshtein.CalculateDistance(string.Empty, "kitten"));
}

[TestMethod()]
public void Test_CalculateDistance_With_Empty_Second_String()
{           
    Assert.AreEqual(6, Levenshtein.CalculateDistance("kitten", string.Empty));
}

[TestMethod()]
public void Test_CalculateDistance_With_Missing_Characters()
{           
    Assert.AreEqual(2, Levenshtein.CalculateDistance("kitten", "kitt"));
}

[TestMethod()]
public void Test_CalculateDistance_With_Wrong_Characters()
{           
    Assert.AreEqual(1, Levenshtein.CalculateDistance("kitten", "kittyn"));
}

[TestMethod()]
public void Test_CalculateDistance_With_Too_Much_Characters()
{           
    Assert.AreEqual(5, Levenshtein.CalculateDistance("kitten", "kittenkitty"));
}

[TestMethod()]
public void Test_CalculateDistance_With_Equal_Strings()
{          
    Assert.AreEqual(0, Levenshtein.CalculateDistance("kitten", "kitten"));
}
```

Now that we have implemented the Levenshtein distance algorithm, we can
calculate the distances between the unknown action name and all the
available action names.  

```csharp
private Dictionary<string, int> CalculateLevenshteinDistance(IEnumerable<string> actionList, string actionName)
{
    return actionList
            .Select(a => new
            {
                Action = a.ToLower(),
                Distance = Levenshtein.CalculateDistance(a.ToLower(), actionName.ToLower())
            })                    
            .ToDictionary(k => k.Action, v => v.Distance);
}
```

For the unknown action name 'Kitty', when the action names 'Kitten',
'Index' and 'Dog' are available, this method would return a dictionary
that looks like this.  

```
'kitten' : 2
'index' : 6
'dog' : 6
```

### Putting it all together  
  
Now we have this dictionary, we want to filter on a certain distance
threshold. I picked three, given that when a word is three characters
off, the chance of it being a typo is rather small.  
  
If the dictionary still contains some items after filtering, we want to take the action with the shortest distance, this action is the nearest to the unknown action. Only thing left to do is change the action in the [RouteData](http://msdn.microsoft.com/en-us/library/system.web.mvc.controller.routedata(v=vs.90).aspx) and execute a [RedirectResult](http://msdn.microsoft.com/en-us/library/system.web.mvc.redirectresult.aspx). The easiest way to generate a url to redirect to, is to use the controller's UrlHelper to let it generate the url based on the RouteData.  

```csharp
private void TryToRedirectToAnActionNearby(string actionName)
{
    var httpGetActionNames = GetAllHttpGetActionNames();
    if (!httpGetActionNames.Any())
        Throw404HttpException(actionName);

    var actionDistanceMap = CalculateLevenshteinDistance(httpGetActionNames, actionName)
                                .Where(i => i.Value <= 3);
    if (!actionDistanceMap.Any())
        Throw404HttpException(actionName);

    var shortestDistance = actionDistanceMap.Select(v => v.Value).Min();
    var nearestAction = actionDistanceMap.Where(i => i.Value == shortestDistance).First().Key;

    ControllerContext.RouteData.Values["action"] = nearestAction;

    new RedirectResult(Url.RouteUrl(RouteData.Values), permanent: true)
        .ExecuteResult(ControllerContext);
}
```

### The outcome  
  
Now when I, the user, type http://somesite/someController/kitty, I will
be redirected to http://somesite/someController/kitten without me even
noticing.  
  
[![](/post/images/thumbnails/2012-01-15-autocorrecting-unknown-actions-using-the-levenshtein-distance-LevenshteinDistanceRedirect.PNG)](/post/images/2012-01-15-autocorrecting-unknown-actions-using-the-levenshtein-distance-LevenshteinDistanceRedirect.PNG)  
  
### Feedback  
  
This implementation definitely is **not production ready**. It's a
prototype, not even under test. I wonder if this  is even something you
would want to do. Or is this **breaking the Web** in one way or the
other? Would it bother search engines?
