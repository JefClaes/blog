+++
title = "HTML5: Drawing images to the canvas gotcha"
slug = "2010-12-05-html5-drawing-images-to-the-canvas-gotcha"
published = 2010-12-05T19:55:00.001000+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2010/12/html5-drawing-images-to-canvas-gotcha.html"
+++
While I was playing with the [Canvas
API](http://www.w3.org/TR/html5/the-canvas-element.html) I came across a
weird issue: I was trying to draw an image to the canvas, but the image
failed to render very often.  
  
Have a look at the source. Do you spot the problem?  
  
```html
<!DOCTYPE html>
<html>
    <head>
        <title>HTML5: Canvas</title>
        <script type="text/javascript">        
            window.addEventListener("load", draw, true);
            
            function draw(){                            
                var canvas = document.getElementById('canvas');
                var context = canvas.getContext('2d');    
 
                var img = new Image();
                img.src = "logo.png";                

                context.drawImage(img, 0, 0);                
            }            
        </script>        
    </head>

    <body>
        <canvas id="canvas" height="500" width="500">
            Looks like canvas isn't supported in your browser! 
        </canvas>
    </body>
</html>
```
  
It wasn't until I opened [Firebug](http://getfirebug.com/) and saw an
unhandled exception in the console that I discovered what was going
on.  

```
uncaught exception: \[Exception... "Component returned failure code:
0x80040111 (NS\_ERROR\_NOT\_AVAILABLE)
\[nsIDOMCanvasRenderingContext2D.drawImage\]" nsresult: "0x80040111
(NS\_ERROR\_NOT\_AVAILABLE)" location: "JS frame :: file:///....html
:: draw :: line 15" data: no\]
```
  
Browsers load images asynchronously while scripts are already being
interpreted and executed. If the image isn't fully loaded the canvas
fails to render it. Turns out the *weird* issue, is pretty logical.  
  
Luckily this isn't hard to resolve. We just have to wait to start
drawing until we receive a callback from the image, notifying loading
has completed.  
  
```js
window.addEventListener("load", draw, true);

function draw(){                                    
    var img = new Image();
    img.src = "logo.png";                

    img.onload = function(){
        var canvas = document.getElementById('canvas');
        var context = canvas.getContext('2d');    

        context.drawImage(img, 0, 0);        
    };            
}                    
```

Et voila!