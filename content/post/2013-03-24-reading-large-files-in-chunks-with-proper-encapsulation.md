+++
title = "Reading large files in chunks with proper encapsulation"
slug = "2013-03-24-reading-large-files-in-chunks-with-proper-encapsulation"
published = 2013-03-24T18:16:00+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET",]
+++
I've been doing some work lately which involves sequentially reading
large files (&gt; 2 to 5GB). This entails that it's not an option to
read the whole structure in memory; it's more reliable to process the
file in chunks. I occasionally come across legacy that solves exactly
this problem, but in a procedural way, resulting in tangled spaghetti.
To be honest, the first piece of software I ever wrote in a professional
setting also went at it in the wrong way.  
  
There is no reason to let it come to this though; you can use the often
overlooked [yield return
keyword](http://msdn.microsoft.com/en-us/library/vstudio/9k7k7cf0.aspx)
to improve encapsulation.  

> When you use the yield keyword in a statement, you indicate that the
> method, operator, or get accessor in which it appears is an iterator.
> You consume an iterator method by using a foreach statement or LINQ
> query. Each iteration of the foreach loop calls the iterator method.
> When a yield return statement is reached in the iterator method,
> expression is returned, and the current location in code is retained.
> Execution is restarted from that location the next time that the
> iterator function is called.

Have a look at the following Reader class which takes advantage of yield
returning. This class reads from file, line by line, building a chunk,
to return it when the desired chunk size is attained. In the next
iteration, the call will continue by clearing the lines - thereby
releasing memory, and rebuilding the next chunk.

    public class Reader
    {
        private int _chunkSize;

        public Reader(int chunkSize) 
        {
            _chunkSize = chunkSize;
        }

        public IEnumerable<Chunk> Read(string path)
        {
            if (string.IsNullOrEmpty(path))
                throw new NullReferenceException("path");

            var lines = new List<string>();

            using (var reader = new StreamReader(path))
            {
                string line;
                while ((line = reader.ReadLine()) != null)
                {
                    lines.Add(line);

                    if (lines.Count == _chunkSize)
                    {
                        yield return new Chunk(lines);

                        lines.Clear();
                    }
                }                
            }

            yield return new Chunk(lines);
        }
    }

    public class Chunk
    {
        public Chunk(List<string> lines) 
        {
            Lines = lines;
        }

        public List<string> Lines { get; private set; }
    }

And that's one way to achieve clean encapsulation without starving your
machine's memory.

    var reader = new Reader(chunkSize: 1000);
    var chunks = reader.Read(@"C:\big_file.txt");

    foreach (var chunk in chunks)            
        Console.WriteLine(chunk.Lines.Count);
