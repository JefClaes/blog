+++
title = "Log4Net: log.Debug(String.Format()) versus log.DebugFormat()"
slug = "2010-01-20-log4net-log-debug-string-format-versus-log-debugformat"
published = 2010-01-20T20:30:00.005000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "Opensource", "Tips",]
+++
[Log4net](http://logging.apache.org/log4net/index.html) is one of the
most popular opensource logging frameworks available in the .NET world.
I've been using this framework for over a year now, and today I
discovered something new.  
  
I often use
[string.Format()](http://msdn.microsoft.com/en-us/library/system.string.format.aspx)
to format my log messages. Earlier this morning I made a typo formatting
my message and an Exception was thrown in the beginning of my method
which caused the application flow to break. You can avoid this by using
the
[DebugFormat()](http://logging.apache.org/log4net/release/sdk/log4net.ILog.DebugFormat_overloads.html)
method. If you mistype here, no Exception will be thrown, but a WARN
message will be logged.  
  
<span style="font-weight:bold;">Example using
log.Debug(String.Format())</span>  

  

       1:  try

       2:  {

       3:      if (log.IsDebugEnabled)

       4:      {

       5:          log.Debug("Starting to insert item ABC_1.");

       6:          //Insert item ABC_1

       7:          log.Debug(string.Format("Item {0} inserted with success. Started inserting item {1}.", "ABC_1"));

       8:          log.Debug("Starting to insert item ABC_2.");

       9:          //Insert item ABC_2

      10:          log.Debug(string.Format("Inserted item {0}.", "ABC_2"));

      11:      }

      12:  }

      13:  catch (Exception ex)

      14:  {

      15:      log.Error("Woops", ex);

      16:  }

  

  
As expected this throws a
"[System.FormatException](http://msdn.microsoft.com/en-us/library/system.formatexception.aspx):
Index (zero based) must be greater than or equal to zero and less than
the size of the argument list."  
  
<span style="font-weight:bold;">Example using log.DebugFormat()</span>  

  

       1:  try

       2:  {

       3:      if (log.IsDebugEnabled)

       4:      {

       5:          log.Debug("Starting to insert item ABC_1.");

       6:          //Insert item ABC_1

       7:          log.DebugFormat("Item {0} inserted with success. Started inserting item {1}.", "ABC_1");

       8:          log.Debug("Starting to insert item ABC_2.");

       9:          //Insert item ABC_2

      10:          log.Debug(string.Format("Inserted item {0}.", "ABC_2"));

      11:      }

      12:  }

      13:  catch (Exception ex)

      14:  {

      15:      log.Error("Woops", ex);

      16:  }

  
Using DebugFormat() the logger logs a WARN message, but it doesn't break
the application flow.  

  

       1:  WARN StringFormat: Exception while rendering format [Item {0} inserted with

       2:  success. Started inserting item {1}.]

  

  
So to avoid logging breaking your application, you should use the
DebugFormat(), WarningFormat(), InfoFormat(), ErrorFormat() methods
instead of String.Format() to format your log message. This should be a
best practice.
