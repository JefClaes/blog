+++
title = "Follow up: Eliminating redundant eventhandlers using a dictionary to map controls"
slug = "2010-07-13-follow-up-eliminating-redundant-eventhandlers-using-a-dictionary-to-map-controls"
published = 2010-07-13T20:55:00.001000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "ASP.NET", "Refactoring", "Tips",]
+++
Yesterday I blogged on '[WebForms refactoring: Eliminating redundant
eventhandlers using a dictionary to map
controls](http://jclaes.blogspot.com/2010/07/webforms-refactoring-eliminating.html)'.
In this post I went from bad code to better code. A smart reader gave me
some good pointers on how to improve [this
code](http://jclaes.blogspot.com/2010/07/webforms-refactoring-eliminating.html)
some more. Another iteration was necessary.  
  
<span style="font-weight:bold;">Losing the Linq</span>  
  
In the previous iteration I used Linq to search my dictionary.  
  

      1:  var res = mappings.Where(map => map.Key.Equals((CheckBox)sender)).First();

  
This is overhead, because the dictionary implements an
[indexer](http://msdn.microsoft.com/en-us/library/6x16t2tx.aspx).  
  

       1:  TextBox[] textBoxes = mappings[checkBox];

  
<span style="font-weight:bold;">Eliminating unnecessary casts</span>  
  
When I got the right dictionary entry I casted the value of the entry to
an array of textboxes.  
  

       1:  TextBox[] textBoxes = (TextBox[])res.Value;

  
Casting the value is unnecessary because I'm using a [generic
dictionary](http://msdn.microsoft.com/en-us/library/xfhwa508.aspx)!  
  

       1:  TextBox[] textBoxes = mappings[checkBox];

  
<span style="font-weight:bold;">Saving a few CPU cycles</span>  
  
I only need to do something with my textboxes when my checkbox is not
checked. Evaluating the Checked property of the sender before doing
something prevents executing useless code.  
  

        1:  protected void chkCase_CheckedChanged(object sender, EventArgs e)

       2:  {

       3:      CheckBox checkBox = (CheckBox)sender;

       4:   

       5:      if (checkBox.Checked)

       6:      {

       7:          return;

       8:      }

       9:      else

      10:      {

      11:          Dictionary<CheckBox, TextBox[]> mappings = new Dictionary<CheckBox, TextBox[]>()

      12:          {

      13:              {this.chkCaseOne, new TextBox[] {this.txtCaseOneFirst, this.txtCaseOneSecond}},

      14:              {this.chkCaseTwo, new TextBox[] {this.txtCaseTwoFirst, this.txtCaseTwoSecond}},

      15:              {this.chkCaseThree, new TextBox[] {this.txtCaseThreeFirst, this.txtCaseThreeSecond}}

      16:          };

      17:   

      18:          TextBox[] textBoxes = mappings[checkBox];

      19:          

      20:          foreach (TextBox textBox in textBoxes)

      21:          {

      22:              textBox.Text = string.Empty;

      23:          }        

      24:      }

      25:  }      

  
<span style="font-weight:bold;">An extra pair of eyes</span>  
  
Thanks for pointing out the things that were still wrong. These
improvements have taken this code snippet to another level again. This
also proves how having an extra pair of eyes can improve the quality of
your code significantly!  
  
<span style="font-weight:bold;">I'm pretty sure there is still room for
some more optimizations?</span>
