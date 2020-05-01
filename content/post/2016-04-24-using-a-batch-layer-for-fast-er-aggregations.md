+++
title = "Using a batch layer for fast(er) aggregations "
slug = "2016-04-24-using-a-batch-layer-for-fast-er-aggregations"
published = 2016-04-24T22:43:00+02:00
author = "Jef Claes"
tags = [ "code",]
url = "2016/04/using-batch-layer-for-faster.html"
+++
In the oldest system I'm maintaining right now, we have an account
aggregate that, next to mutating various balances, produces immutable
financial transactions. These transactions are persisted together with
the aggregate itself to a relational database. The transactions can be
queried by the owner of the account in an immediate consistent
fashion.  
  
The table with these transactions looks similar to this:

```sql
CREATE TABLE [dbo].[Transaction] (
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Timestamp] [datetime] NULL,
	[AccountId] [int] NOT NULL,
	[TransactionType] [varchar](25) NOT NULL,
	[CashAmount] [decimal](19, 2) NOT NULL,
	[BonusAmount] [decimal](19, 2) NOT NULL,
	[...] [...] () NULL /* Too much metadata I'm not very happy about */
CONSTRAINT [Tx_PK] PRIMARY KEY CLUSTERED ( [Id] ASC) 
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
``` 

There's an index on the timestamp, the account identifier and the
transaction type, which allows for *fast enough* reads for the most
common access patterns which only return a small subset.  
  
In a use case we recently worked on, we wanted real-time statistics of
an account's transactions over its life time.  

```sql
SELECT
  TransactionType,
  SUM(CashAmount) AS CashAmount,
  SUM(BonusAmount) AS BonusAmount,
  COUNT(*) AS Count,
  /* ... */
FROM Transaction
WHERE AccountId = @AccountId
GROUP BY TransactionType, /* ... */
```

Running this query would seek the account id index, to look up all rows
that match given predicate. In case one account has tens of thousands of
transactions, this results in a high amount of reads. In case your
database fits into memory, SQL Server can probably satisfy your query
looking in its buffer cache. Although this still has overhead, it's
supposed to be a lot faster than when SQL Server is forced to do
physical reads - reading pages straight from disk. In this case, where
transactions are often years old, and the database does not fit into
memory, odds are high that SQL Server will be reading from disk - which
is dog-slow.  
  
One option would be to create a new covering index (including columns
like CashAmount etc) for this specific workload. The problem is that
indexes don't come for free. You pay for them on every write, and
depending on your performance goals, that might be a cost you want to
avoid. It might even be impossible, or too expensive to create such an
index on environments that have no maintenance window and no license
that allows for online index builds. Assuming that when you don't own
said license, you don't have read replicas available either.  
  
Considering the workload, the never-changing nature of financial
transactions and constraints in place, we applied [Lambda
Architecture](https://en.wikipedia.org/wiki/Lambda_architecture) theory
on a small scale, starting by building daily aggregations of
transactions per account.  
  
This translates into scheduling a job which catches up all days, by
performing a query per day and appending the results to a specific
table.  

```sql
/** Aggregate transactions by day **/
INSERT INTO [dbo].[DailyTransactionAggregation]
   SELECT
     CONVERT(DATE, Timestamp) AS Datestamp,
     AccountId
     TransactionType
     COUNT(*) AS Count,
     SUM(CashAmount) AS CashAmount,
     SUM(BonusAmount) AS BonusAmount,
     /* ... */
   FROM [dbo].[Transaction]
   WHERE Timestamp >= :start AND Timestamp < :end
   GROUP BY CONVERT(DATE, Timestamp), TransactionType, AccountId,   /* ... */
```

On our dataset, this compresses the transaction table by a factor of
more than 300. Not just that, by separating reads from writes, we give
ourselves so much more breathing room and options, which makes me sleep
so much better at night.  
  
As you probably noticed, for real-time statistics on this data, we're
still missing today's transactions in this table. Since today's
transactions are a much smaller subset and likely to live in SQL
Server's cache, we can query both the batch table and the transaction
table, to eventually merge the results of both queries. For our use
case, resource usage and query response times have dropped
significantly, especially for the *largest* accounts.  
  
I don't see it happening in the near future, but in case the usage of
these queries grows, we can still borrow more Lambda Architecture
practices and push further.
