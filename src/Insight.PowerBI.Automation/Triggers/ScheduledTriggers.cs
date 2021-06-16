using System;
using System.IO;
using System.Threading.Tasks;
using System.Web;
using Insight.PowerBI.Core.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Insight.PBIAutomation.Triggers
{
    public class ScheduledTriggers
    {
        private readonly ICosmosDbService cosmosDbService;

        public ScheduledTriggers(ICosmosDbService cosmosDbService)
        {
            this.cosmosDbService = cosmosDbService;
        }

        [FunctionName("SubscriptionsList")]
        public async Task<IActionResult> WorkspaceList(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("WorkspaceList activated.");
            var id = req.Query["id"];
            await cosmosDbService.GetItemsAsync();

            return new OkResult();
        }
    }
}

