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
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Threading.Tasks;

namespace Insight.PBIAutomation.Triggers
{
    public class SubscriptionTriggers
    {
        private readonly ICosmosDbService cosmosDbService;
        private readonly CosmosDbOptions options;

        public SubscriptionTriggers(ICosmosDbService cosmosDbService, IOptions<CosmosDbOptions> options)
        {
            this.cosmosDbService = cosmosDbService;
            this.options = options.Value;
        }

        [FunctionName("Subscription")]
        public IActionResult GetSubscription(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            [CosmosDB(
                databaseName: "%cosmosDbName%",
                collectionName: "%SubscriptionContainerName%",
                ConnectionStringSetting = "CosmosDBConnection",
                Id = "{Query.id}",
                PartitionKey = "{Query.id}")]SubscriptionItem subscriptionItem,
            ILogger log)
        {
            log.LogInformation("GetSubscription activated.");
            return new OkObjectResult(subscriptionItem);
        }

        [FunctionName("SubscriptionList")]
        public async Task<IActionResult> GetSubscriptionListAsync(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("GetSubscriptionListAsync activated.");
            var items = await cosmosDbService.GetItemsAsync<SubscriptionItem>(options.SubscriptionContainerName);
            return new OkObjectResult(items);
        }

        [FunctionName("Subscription")]
        public async Task<IActionResult> CreateSubscriptionAsync(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            SubscriptionItem data = JsonConvert.DeserializeObject<SubscriptionItem>(requestBody);

            log.LogInformation("CreateSubscriptionAsync activated.");
            var items = await cosmosDbService.CreateItemAsync(options.SubscriptionContainerName, data, (x) => x.id);
            return new OkObjectResult(items);
        }
    }
}

