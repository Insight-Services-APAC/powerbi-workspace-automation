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
        public ScheduledTriggers(IWorkspaceExtractOrchestration workspaceExtract)
        {
            WorkspaceExtract = workspaceExtract;
        }

        public IWorkspaceExtractOrchestration WorkspaceExtract { get; }

        [FunctionName("ActivitiesScheduled")]
        public async Task<IActionResult> WorkspaceList(
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
            log.LogInformation("WorkspaceList activated.");
            var a = await WorkspaceExtract.ActivitiesAsync(activityDate);
            return new OkObjectResult(a);
        }
    }
}

