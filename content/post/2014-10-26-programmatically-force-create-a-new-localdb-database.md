+++
title = "Programmatically force create a new LocalDB database"
slug = "2014-10-26-programmatically-force-create-a-new-localdb-database"
published = 2014-10-26T16:59:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "SQL", "SQLServer",]
+++
I have spent the last week working in an integration test suite that
seemed to be taking ages to run its first test. I ran a profiler on the
setup, and noticed a few things that were cheap to improve. The first
one was how a new LocalDB database was being created.  
An empty database file was included into the project. When running the
setup, this file would replace the existing test database. However, when
there were open connections to the test database - SQL Server Management
Studio for example - replacing it would fail. To avoid this, the SQL
server process was being killed before copying the file, waiting for it
to come back up.  
  
Another way to create a new database, is by running a script on master.
You can force close open connections to the existing database, by
putting the database in single user mode and rolling back open
transactions. You can also take advantage of creation by script to set
up a sane size to avoid the database having to grow while running your
tests. When you specify the database size, you need to also specify the
filename; I'm using the default location.

  

Switching to this approach shaved seven seconds of database creation.
