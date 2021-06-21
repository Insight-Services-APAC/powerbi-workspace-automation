using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Insight.PowerBI.Core.Exceptions;
using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Models;
using Insight.PowerBI.Core.Options;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace Insight.PBIAutomation.Triggers
{
    public class ActivityTriggers
    {
        private readonly ICosmosDbService cosmosDbService;
        private readonly CosmosDbOptions options;

        public ActivityTriggers(ICosmosDbService cosmosDbService, IOptions<CosmosDbOptions> options)
        {
            this.cosmosDbService = cosmosDbService;
            this.options = options.Value;
        }

        [FunctionName("Activity")]
        public async Task<IActionResult> ActivityGetAsync(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            [CosmosDB(
                databaseName: "%cosmosDbName%",
                collectionName: "%SubscriptionContainerName%",
                ConnectionStringSetting = "CosmosDBConnection",
                Id = "{Query.id}",
                PartitionKey = "{Query.id}")]SubscriptionItem subscriptionItem,
            ILogger log)
        {

            log.LogInformation("ActivityGet activated.");
            var result = await cosmosDbService.GetItemsAsync<PowerBIActivity>(options.ActivitiesContainerName);
            
            return new OkObjectResult(result.Select(x => x.Payload));
        }
    }
}
