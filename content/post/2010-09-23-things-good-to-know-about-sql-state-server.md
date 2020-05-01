+++
title = "Things good to know about SQL State Server"
slug = "2010-09-23-things-good-to-know-about-sql-state-server"
published = 2010-09-23T19:31:00.014000+02:00
author = "Jef Claes"
tags = [ "SQL", "ASP.NET", "Tips",]
+++
While installing a [SQL State
Server](http://msdn.microsoft.com/en-us/library/ms178586.aspx) last
week, I came across a few things worth sharing about the installation
and use of SQL State Server.  
  
<span style="font-weight:bold;">Finding a good tutorial</span>  
  
There are lots of tutorials out there on how to install SQL State Server
but most of them are not great. To do a basic installation you only need
this Msdn documentation on how to [run the Aspnet\_regsql.exe
tool](http://msdn.microsoft.com/en-us/library/h6bb9cz9(VS.71).aspx) and
[edit your
web.config](http://msdn.microsoft.com/en-us/library/h6bb9cz9(VS.71).aspx).  
  
<span style="font-weight:bold;">All the objects in Session need to be
serializable</span>  
  
If you try to store an object in Session which isn't marked as
serializible an
[HttpException](http://msdn.microsoft.com/en-us/library/system.web.httpexception.aspx)
will get thrown with following message.  

> Unable to serialize the session state. In 'StateServer' and
> 'SQLServer' mode, ASP.NET will serialize the session state objects,
> and as a result non-serializable objects or MarshalByRef objects are
> not permitted. The same restriction applies if similar serialization
> is done by the custom session state store in 'Custom' mode.

Marking your classes with the [Serializible
attribute](http://msdn.microsoft.com/en-us/library/system.serializableattribute.aspx)
shouldn't be a problem. Be careful when storing WebControls in Session
though, most of these aren't marked as serializible!  
  
When you are using UpdatePanels this exception doesn't fully propagate
to the front-end. The javascript error shown will have following
message.  

> Error: Sys.WebForms.PageRequestManagerServerErrorException: An unknown
> error occurred while processing the request on the server. The status
> code returned from the server was: 500

<span style="font-weight:bold;">Use the same machinekey on multiple
servers</span>  
  
To make the SQL State Server work across servers hosting the same
application, you need to make sure the [machineKey
element](http://msdn.microsoft.com/en-us/library/w8h3skw9.aspx) in the
machine.config is identical.  
  
<span style="font-weight:bold;">Redundancy options are limited</span>  
  
Looking at the [Msdn
documentation](http://msdn.microsoft.com/en-us/library/ms178586.aspx),
it looks like only [SQL Server
clustering](http://www.sql-server-performance.com/articles/clustering/clustering_intro_p1.aspx)
is supported. You can't specify a Failover Partner, so [SQL Server
mirroring](http://msdn.microsoft.com/en-us/library/ms131373.aspx) isn't
supported.  

> In SQLServer mode, you can configure several computers running SQL
> Server to work as a failover cluster, which is two or more identical
> computers running SQL Server that store data for a single database. If
> one computer running SQL Server fails, another server in the cluster
> can take over and serve requests without session-data loss.

<span style="font-weight:bold;">More experience?</span>  
  
Do you know more things good to know about SQL State Server?
