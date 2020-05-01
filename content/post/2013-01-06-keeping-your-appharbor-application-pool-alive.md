+++
title = "Keeping your AppHarbor application pool alive"
slug = "2013-01-06-keeping-your-appharbor-application-pool-alive"
published = 2013-01-06T21:18:00+01:00
author = "Jef Claes"
tags = [ ".NET", "Hacking", "ASP.NET", "NancyFx",]
+++
By default, IIS will shut down your application pool when it has been
idle for more than 20 minutes. This is annoying when your website is
only visited sporadically; visitors might not have the patience to wait
for your application pool to spin up again. When you're running your own
machine, you can higher or disable the idle-timeout, but when you're
running on a cloud service like [AppHarbor](https://appharbor.com/) you
can't.  
  
One solution is to frequently make a request yourself to keep the
application pool alive. You can use a third party service (like
[Pingdom](https://www.pingdom.com/) or
[StillAlive](https://stillalive.com/)), but chances are you don't want
to take an extra dependency for something that trivial.  
  
AppHarbor contains the required infrastructure to do this yourself:
[background
workers](http://support.appharbor.com/kb/getting-started/background-workers)
and
[scheduling](http://blog.appharbor.com/2012/4/18/scheduled-tasks-using-quartz-and-appharbor-background-workers).  
  
First create a new [Quartz](http://quartznet.sourceforge.net/) job which
makes a request to your web application when it's invoked.

    public class KeepAliveJob : IJob
    {
        public void Execute(IJobExecutionContext context)
        {
            using (WebClient client = new WebClient())
            {
                client.DownloadString("http://your_webapp.com");
            }
        }
    }

Then schedule your job to be triggered every 19 minutes or so.  

    var keepAliveJob = JobBuilder.Create<KeepAliveJob>().Build();
    var keepAliveTrigger = TriggerBuilder.Create()
                    .WithSimpleSchedule(x => x.WithIntervalInMinutes(19).RepeatForever())
                    .Build();

    scheduler.ScheduleJob(keepAliveJob, keepAliveTrigger);    
    scheduler.Start();   

And that should be it; you're now running your own ping service.<span
class="Apple-tab-span" style="white-space: pre;"> </span>
