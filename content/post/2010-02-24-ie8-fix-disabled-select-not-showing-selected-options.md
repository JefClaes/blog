+++
title = "IE8-Fix: Disabled select not showing selected options"
slug = "2010-02-24-ie8-fix-disabled-select-not-showing-selected-options"
published = 2010-02-24T19:55:00.007000+01:00
author = "Jef Claes"
tags = [ "CSS", "Browsers", "Hack", "Tips",]
+++
In this post a small workaround for disabled select not showing selected
options in IE8. It's probably not the cleanest fix, but it get's the job
done.  
  
<span style="font-weight:bold;">Problem</span>  
  
A disabled select does not highlight the selected options.  

  

       1:  <select size="3" multiple="multiple" id="mySelect" disabled="disabled">

       2:      <option selected="selected" value="Option1">Option 1</option>

       3:      <option selected="selected" value="Option2">Option 2</option>

       4:      <option value="Option3">Option 3</option>        

       5:  </select>  

  

[![](/post/images/thumbnails/2010-02-24-ie8-fix-disabled-select-not-showing-selected-options-NotFixed.JPG)](/post/images/2010-02-24-ie8-fix-disabled-select-not-showing-selected-options-NotFixed.JPG)  
  
<span style="font-weight:bold;">Solution</span>  
  
The following CSS provides a workaround. It looks pretty similar to the
appearance we are used to.  

  

       1:  select[disabled="disabled"][multiple="multiple"]{

       2:      background-color:#D4D0C8;

       3:  } 

       4:   

       5:  select[disabled="disabled"][multiple="multiple"] option[selected="selected"]{

       6:      background-color:navy;

       7:  }  

  
[![](/post/images/thumbnails/2010-02-24-ie8-fix-disabled-select-not-showing-selected-options-Fixed.JPG)](/post/images/2010-02-24-ie8-fix-disabled-select-not-showing-selected-options-Fixed.JPG)  
  
<span style="font-weight:bold;">Still not working?</span>  
  
Make sure you are using a transitional doctype.  
  

       1:  <!-- DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" -->

  

You can also try to force the compatibility mode.

  

       1:  <meta http-equiv="X-UA-Compatible" content="IE=8"> 

  

<span style="font-weight:bold;">Disclaimer</span>  
  
I tested this on IE8, FireFox and Opera.  
  
<span style="font-weight:bold;">Better fix?</span>  
  
Please let me know!
