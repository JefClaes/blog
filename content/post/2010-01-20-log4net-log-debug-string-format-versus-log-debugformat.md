+++
title = "Log4Net: log.Debug(String.Format()) versus log.DebugFormat()"
slug = "2010-01-20-log4net-log-debug-string-format-versus-log-debugformat"
published = 2010-01-20T20:30:00.005000+01:00
author = "Jef Claes"
tags = [ "code",]
url = "2010/01/log4net-logdebugstringformat-versus.html"
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
method. If you mistype here, no exception will be thrown, but a `WARN`
message will be logged.  
  
### Example using `String.Format`  

```cs
log.Debug(string.Format("{0}{1}", "ABC_1"));
```

As expected this throws a [System.FormatException](http://msdn.microsoft.com/en-us/library/system.formatexception.aspx): `Index (zero based) must be greater than or equal to zero and less than the size of the argument list.`  
  
### Example using `log.DebugFormat` 

```cs
log.DebugFormat("{0}{1}", "ABC_1");
```

Using `DebugFormat()` the logger logs a `WARN` message, but it doesn't break
the application flow.  

```
WARN StringFormat: Exception while rendering format [{0} {1}.]
```
    
So to avoid logging breaking your application, you should use the
`DebugFormat()`, `WarningFormat()`, `InfoFormat()`, `ErrorFormat()` methods
instead of `String.Format()` to format your log message.