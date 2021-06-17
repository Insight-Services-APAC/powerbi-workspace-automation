using Insight.PowerBI.Core.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

namespace Insight.PBIAutomation.Triggers
{
    public class ScheduledTriggers
    {
        private readonly ICosmosDbService cosmosDbService;

        public ScheduledTriggers(IWorkspaceExtractOrchestration workspaceExtract)
        {
            WorkspaceExtract = workspaceExtract;
        }

        public IWorkspaceExtractOrchestration WorkspaceExtract { get; }

        [FunctionName("SubscriptionsList")]
        public async Task<IActionResult> WorkspaceList(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("WorkspaceList activated.");
            //await WorkspaceExtract.WorkspaceETLAsync();
            var a = await WorkspaceExtract.ActivitiesAsync();
            return new OkObjectResult(a);
        }
    }
}

