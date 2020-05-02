+++
title = "Solving Mavericks with VMware Fusion 6 and Windows 8.1 hangs"
slug = "2014-04-21-solving-mavericks-with-vmware-fusion-6-and-windows-8-1-hangs"
published = 2014-04-21T12:07:00+02:00
author = "Jef Claes"
tags = [ ]
url = "2014/04/solving-mavericks-with-vmware-fusion-6.html"
+++
Since I intended to avoid Windows at home, I got a Macbook Pro starting
out at my new job. Overall it has been a great machine for doing
development; it's fast, light enough to carry around, its battery life
is outstanding, it has a screen that's gentle to the eyes, and full
screen apps together with powerful mouse gestures allow me to quickly
shuffle between things not missing touch or a second monitor.  
  
Most of my professinal work is still on the Microsoft stack though, so
I'm running a Windows 8.1 VM on VMWare Fusion 6. Much to my frustration,
this setup would gradually slow down my system until it would completely
grind to a halt every few hours. After complaining about it on Twitter,
people said that having 8GB of RAM with half of that allocated to the VM
might not be enough.  
  
However after applying some tweaks, I got my system to chug away for a
week without any hangs.  
  
Here is what I changed:  

1.  [Turn off App Nap for
    VMware](https://communities.vmware.com/thread/460957)
2.  [Install Memory
    Clean](http://lifehacker.com/memory-clean-frees-up-your-macs-unused-system-reserve-1486621856)
3.  Disable Windows visual effects (Advanced System Settings - Visual
    Effects)
4.  [Turn off Resharper Solution-Wide
    Analysis](http://confluence.jetbrains.com/display/NETCOM/Ultimate+Guide+to+Speeding+Up+ReSharper+(and+Visual+Studio)#UltimateGuidetoSpeedingUpReSharper%28andVisualStudio%29-TurnoffSolutionWideAnalysis)
5.  [Turn off Visual Studio rich client visual
    experience ](http://confluence.jetbrains.com/display/NETCOM/Ultimate+Guide+to+Speeding+Up+ReSharper+(and+Visual+Studio)#UltimateGuidetoSpeedingUpReSharper%28andVisualStudio%29-Speedupeditorscrolling)

Hope it helps.
