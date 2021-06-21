using Insight.PowerBI.Core.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;

namespace Insight.PBIAutomation.Triggers
{
    public class ScheduledTriggers
    {
        public ScheduledTriggers(IPowerBIETLOrchestration workspaceExtract)
        {
            WorkspaceExtract = workspaceExtract;
        }

        public IPowerBIETLOrchestration WorkspaceExtract { get; }

        [FunctionName("ActivitiesScheduled")]
        public async Task<IActionResult> ActivitiesScheduled(
            //[TimerTrigger("0 0 1 * * *", RunOnStartup = false, UseMonitor = true)] TimerInfo timmer,
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            var activityDateString = req.Query["activityDate"].ToString();
            DateTime? activityDate = null;
            if (!string.IsNullOrEmpty(activityDateString))
            {
                DateTime tmp;
                if (DateTime.TryParse(activityDateString, out tmp))
                {
                    activityDate = tmp;
                }
            }
            log.LogInformation("ActivitiesScheduled activated.");
            var a = await WorkspaceExtract.ActivitiesAsync(activityDate);
            return new OkObjectResult(a);
        }

        [FunctionName("WorkspacesScheduled")]
        public async Task<IActionResult> WorkspacesScheduled(
            //[TimerTrigger("0 0 1 * * *", RunOnStartup = false, UseMonitor = true)] TimerInfo timmer,
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("ActivitiesScheduled activated.");
            await WorkspaceExtract.WorkspacesAsync();
            return new OkResult();
        }
    }
}

