+++
title = "Quick and dirty tool for sending UDP packets"
slug = "2010-03-15-quick-and-dirty-tool-for-sending-udp-packets"
published = 2010-03-15T18:57:00.004000+01:00
author = "Jef Claes"
tags = [ "CodeSnippets", "Tools", ".NET", "Tips",]
+++
While I was playing with my
[UDPListener](http://jclaes.blogspot.com/2010/03/listening-for-udp-packets-in-windows.html)
I needed a small tool which could send some UDP packets to a certain
hostname and port. That's why I wrote a console application which uses
an
[UdpClient](http://msdn.microsoft.com/en-us/library/system.net.sockets.udpclient.aspx)
to [send](http://msdn.microsoft.com/en-us/library/08h8s12k.aspx) some
UDP packets. It's quick and dirty, but it serves the cause.  

  

       1:  namespace UdpSender

       2:  {

       3:      class Program

       4:      {

       5:          //Constants

       6:          private const string HOSTNAME = "LocalHost";

       7:          private const int PORT = 800;

       8:          private const int TIMES = 5;

       9:          private const string MESSAGE = "This is a TestMessage";

      10:          private const int SLEEP = 50;

      11:   

      12:          static void Main(string[] args)

      13:          {

      14:              using (UdpClient client = new UdpClient())

      15:              {

      16:                  //Connect

      17:                  client.Connect(HOSTNAME, PORT);

      18:                  Console.WriteLine(string.Format("Connected to {0}:{1}.", HOSTNAME, PORT));

      19:                  Console.WriteLine("Start sending packets..");

      20:   

      21:                  //Send packets

      22:                  int timesSent = 0;

      23:                  while (timesSent < TIMES)

      24:                  {

      25:                      timesSent++;

      26:   

      27:                      //Convert the message to a Byte array

      28:                      Byte[] mess = Encoding.ASCII.GetBytes(MESSAGE);

      29:   

      30:                      //Send the message

      31:                      client.Send(mess, mess.Count());

      32:   

      33:                      Console.WriteLine(string.Format("Message {0} sent..", timesSent));

      34:                      //Sleep for a while

      35:                      Thread.Sleep(SLEEP);

      36:                  }

      37:   

      38:                  //Close the client

      39:                  client.Close();

      40:              }

      41:   

      42:              Console.WriteLine("Finished sending packets..");

      43:              Console.ReadLine();

      44:          }

      45:      }

      46:  }
