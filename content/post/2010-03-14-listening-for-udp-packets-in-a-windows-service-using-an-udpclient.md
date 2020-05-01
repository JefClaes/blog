+++
title = "Listening for UDP packets in a Windows service using an UdpClient"
slug = "2010-03-14-listening-for-udp-packets-in-a-windows-service-using-an-udpclient"
published = 2010-03-14T16:00:00.006000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", ".NET", "Windows", "Windows Services",]
+++
In this post, I'll show you how can you listen for [UDP
packets](http://en.wikipedia.org/wiki/User_Datagram_Protocol) in a
Windows service.  
  
<span style="font-weight: bold;">OnStart</span>  
  
When the service starts, I set the started flag to true, initialize the
[ManualResetEvent](http://msdn.microsoft.com/en-us/library/system.threading.manualresetevent.aspx),
initialize an
[UdpClient](http://msdn.microsoft.com/en-us/library/system.net.sockets.udpclient.aspx)
and a WorkingThread. The ManualResetEvent will help us on a later stage
to make our service stop elegantly.  

  

       1:  protected override void OnStart(string[] args)

       2:  {

       3:       Start();

       4:  }

       5:       

       6:  public void Start()

       7:  {

       8:       m_started = true;

       9:   

      10:       m_stop = new ManualResetEvent(false);

      11:   

      12:       InitializeUdpListener();

      13:       InitializeWorkingThread();

      14:  }

  
<span style="font-weight: bold;">Initializing</span>  
  
First we need to initialize an
[IPEndpoint](http://msdn.microsoft.com/en-us/library/system.net.ipendpoint.aspx).
When the IPEndpoint is initialized we can initialize the
[UdpClient](http://msdn.microsoft.com/en-us/library/system.net.sockets.udpclient.aspx)
using that
[IPEndpoint](http://msdn.microsoft.com/en-us/library/system.net.sockets.udpclient.aspx).  

  

       1:  private void InitializeUdpClient()

       2:  {

       3:       m_endPoint = new IPEndPoint(IPAddress.Any, PORT_NUMBER);            

       4:       m_client = new UdpClient(m_endPoint);

       5:  }

  
After initializing our
[UdpClient](http://msdn.microsoft.com/en-us/library/system.net.sockets.udpclient.aspx),
we can initialize and start the WorkingThread.  

  

       1:  private void InitializeWorkingThread()

       2:  {

       3:       m_workingThread = new Thread(WorkerFunction);

       4:       m_workingThread.Name = "WorkingThread";

       5:       m_workingThread.Start();

       6:  }

  

  
<span style="font-weight: bold;">WorkerFunction</span>  
  
The WorkerFunction does all the work.  
  
While the service is started, we start [receiving
packets](http://msdn.microsoft.com/en-us/library/system.net.sockets.udpclient.beginreceive.aspx).
We pass in an [AsyncCallback
Delegate](http://msdn.microsoft.com/en-us/library/system.asynccallback.aspx)
which is called when the asynchronous operation completes. In this
delegate we make sure that the result we receive is complete. If the
result is complete we [end
receiving](http://msdn.microsoft.com/en-us/library/system.net.sockets.udpclient.endreceive.aspx)
and get the content of the UDP packet.  
  
Finally we use the
[WaitHandle](http://msdn.microsoft.com/en-us/library/tdykks7z.aspx) to
wait for either the asynchronous operation to complete or the
workerthread to grant a termination request through the stop
[ManualResetEvent](http://msdn.microsoft.com/en-us/library/system.threading.manualresetevent.aspx).  

  

       1:  private void WorkerFunction()

       2:  {

       3:       while (m_started)

       4:       {

       5:           //BeginReceive starts an asynchronous operation, in reality to allow us to achieve

       6:           //semi-synchronous invocation, where we wait for either the asynchronous operation

       7:           //to complete or the worker thread to grant a termination request through stop

       8:           var res = m_client.BeginReceive(iar =>

       9:           {

      10:                if (iar.IsCompleted)

      11:                {

      12:                     byte[] receivedBytes = m_client.EndReceive(iar, ref m_endPoint);

      13:                     string receivedPacket = Encoding.ASCII.GetString(receivedBytes);

      14:                }

      15:            }, null);

      16:   

      17:            if (WaitHandle.WaitAny(new[] { m_stop, res.AsyncWaitHandle }) == 0)

      18:            {

      19:                break;

      20:            }

      21:       }

      22:  }        

  
<span style="font-weight: bold;">OnStop</span>  
  
In the OnStop event we need to set the
[ManualResetEvent](http://msdn.microsoft.com/en-us/library/system.threading.manualresetevent.aspx),
so our WorkerFunction can exit gracefully.  

  

       1:  protected override void OnStop()

       2:  {

       3:      m_stop.Set();

       4:      m_started = false;

       5:  }

  
I'm pretty sure this is a robust solution. A service based on this
example deployed to production has been handling 1000 packets an hour on
average for the last three weeks without problems.  
  
Thanks to [Bart De Smet](http://bartdesmet.net/blogs/bart/) for helping
me out with the threading stuff!
