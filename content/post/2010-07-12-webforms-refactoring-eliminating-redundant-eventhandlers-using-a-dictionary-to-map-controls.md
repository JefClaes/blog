+++
title = "WebForms refactoring: Eliminating redundant eventhandlers using a dictionary to map controls"
slug = "2010-07-12-webforms-refactoring-eliminating-redundant-eventhandlers-using-a-dictionary-to-map-controls"
published = 2010-07-12T21:35:00.002000+02:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "ASP.NET", "Refactoring", "Tips",]
+++
Last week I came across a problem which seemed trivial at first sight,
but turned out to be a pretty fun refactoring challenge.  
  
<span style="font-weight:bold;">The scenario</span>  
  
The real problem was a bit more complex, but for simplicity's sake I
made this example. In this form there are three checkboxes which map
with the textboxes next to them. If the checkbox gets unchecked the
corresponding textboxes should be cleared.  
  
[![](../images/thumbnails/2010-07-12-webforms-refactoring-eliminating-redundant-eventhandlers-using-a-dictionary-to-map-controls-Example.PNG)](../images/2010-07-12-webforms-refactoring-eliminating-redundant-eventhandlers-using-a-dictionary-to-map-controls-Example.PNG)  
  
<span style="font-weight:bold;">First iteration</span>  
  
<span style="font-style:italic;">I warn you. This might make your eyes
bleed.</span>  
  

       1:  protected void chkCaseOne_CheckedChanged(object sender, EventArgs e)

       2:  {

       3:      bool isChecked = (((CheckBox)sender).Checked);

       4:   

       5:      if (!isChecked)

       6:      {

       7:          this.txtCaseOneFirst.Text = string.Empty;

       8:          this.txtCaseOneSecond.Text = string.Empty;

       9:      }

      10:  }

      11:   

      12:  protected void chkCaseTwo_CheckedChanged(object sender, EventArgs e)

      13:  {

      14:      bool isChecked = (((CheckBox)sender).Checked);

      15:   

      16:      if (!isChecked)

      17:      {

      18:          this.txtCaseTwoFirst.Text = string.Empty;

      19:          this.txtCaseTwoSecond.Text = string.Empty;

      20:      }

      21:  }

      22:   

      23:  protected void chkCaseThree_CheckedChanged(object sender, EventArgs e)

      24:  {

      25:      bool isChecked = (((CheckBox)sender).Checked);

      26:   

      27:      if (!isChecked)

      28:      {

      29:          this.txtCaseThreeFirst.Text = string.Empty;

      30:          this.txtCaseThreeSecond.Text = string.Empty;

      31:      }

      32:  }

  
  
Every developer should be able to see the horror in this Copy-Paste
fiesta.  
  
<span style="font-weight:bold;">Second iteration</span>  
  
The obvious next step is extracting the repeated logic into a method.  
  

       1:  protected void chkCaseOne_CheckedChanged(object sender, EventArgs e)

       2:  {

       3:      this.ClearTextBoxesIfCheckBoxNotChecked(

       4:          (CheckBox)sender,

       5:          new TextBox[] { this.txtCaseOneFirst, this.txtCaseOneSecond });

       6:  }

       7:   

       8:  protected void chkCaseTwo_CheckedChanged(object sender, EventArgs e)

       9:  {

      10:      this.ClearTextBoxesIfCheckBoxNotChecked(

      11:          (CheckBox)sender,

      12:          new TextBox[] { this.txtCaseTwoFirst, this.txtCaseTwoSecond });

      13:  }

      14:   

      15:  protected void chkCaseThree_CheckedChanged(object sender, EventArgs e)

      16:  {

      17:      this.ClearTextBoxesIfCheckBoxNotChecked(

      18:          (CheckBox)sender,

      19:          new TextBox[] { this.txtCaseThreeFirst, this.txtCaseThreeSecond });

      20:  }

      21:   

      22:  private void ClearTextBoxesIfCheckBoxNotChecked(CheckBox checkBox, TextBox[] textBoxes)

      23:  {

      24:      if (!checkBox.Checked)

      25:      {

      26:          foreach (TextBox textBox in textBoxes)

      27:          {

      28:              textBox.Text = string.Empty;

      29:          }

      30:      }

      31:  }

  
This is better, but I'm still not satisfied. Those three eventhandlers
seem to be overhead, and are just cluttering my code-behind.  
  
<span style="font-weight:bold;">Third and final iteration</span>  
  
In the final iteration I get rid of the three seperate eventhandlers. I
use a dictionary to create a mapping between the checkboxes and their
corresponding textboxes. Using the eventhandlers sender I get the
matching mapping in the dictionary. Once the matching mapping is found I
extract the checkbox and its corresponding textboxes from the
keyvaluepair and apply the logic.  
  

       1:  protected void chkCase_CheckedChanged(object sender, EventArgs e)

       2:  {

       3:      Dictionary<CheckBox, TextBox[]> mappings = new Dictionary<CheckBox, TextBox[]>()

       4:      {

       5:          {this.chkCaseOne, new TextBox[] {this.txtCaseOneFirst, this.txtCaseOneSecond}},

       6:          {this.chkCaseTwo, new TextBox[] {this.txtCaseTwoFirst, this.txtCaseTwoSecond}},

       7:          {this.chkCaseThree, new TextBox[] {this.txtCaseThreeFirst, this.txtCaseThreeSecond}}

       8:      };

       9:   

      10:      var res = mappings.Where(map => map.Key.Equals((CheckBox)sender)).First();

      11:   

      12:      CheckBox checkBox = (CheckBox)res.Key;

      13:      TextBox[] textBoxes = (TextBox[])res.Value;

      14:   

      15:      if (!checkBox.Checked)

      16:      {

      17:          foreach (TextBox textBox in textBoxes)

      18:          {

      19:              textBox.Text = string.Empty;

      20:          }

      21:      }           

      22:  } 

  
<span style="font-weight:bold;">One more iteration?</span>  
  
I'm pretty satisfied with the last iteration. <span
style="font-weight:bold;">Are you?</span>  
  
<span style="font-style:italic;">You can find the follow-up
[here](http://jclaes.blogspot.com/2010/07/follow-up-eliminating-redundant.html).</span>
