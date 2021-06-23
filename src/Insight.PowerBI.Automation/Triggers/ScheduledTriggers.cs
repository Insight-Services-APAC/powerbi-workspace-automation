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
        private IPowerBIETLOrchestration workspaceExtract;
        public ScheduledTriggers(IPowerBIETLOrchestration workspaceExtract)
        {
            this.workspaceExtract = workspaceExtract;
        }

        [FunctionName("ActivitiesTrigger")]
        public async Task<IActionResult> ActivitiesTriggerAsync(
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
            var a = await workspaceExtract.ActivitiesAsync(activityDate);
            return new OkObjectResult(a);
        }

        [FunctionName("ActivitiesScheduled")]
        public async Task ActivitiesScheduledAsync(
            [TimerTrigger("0 0 1 * * *", RunOnStartup = false)] TimerInfo timer,
            ILogger log)
        {
            log.LogInformation("ActivitiesScheduled activated.");
            await workspaceExtract.ActivitiesAsync(DateTime.UtcNow.AddDays(-1));
        }

        [FunctionName("WorkspacesTrigger")]
        public async Task<IActionResult> WorkspacesTriggerAsync(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("WorkspacesScheduled activated.");
            await workspaceExtract.WorkspacesAsync();
            return new OkResult();
        }

        [FunctionName("WorkspacesScheduled")]
        public async Task WorkspacesScheduledAsync(
            [TimerTrigger("0 0 1 * * *", RunOnStartup = false)] TimerInfo timer,
            ILogger log)
        {
            log.LogInformation("WorkspacesScheduled activated.");
            await workspaceExtract.WorkspacesAsync();
        }
    }
}

