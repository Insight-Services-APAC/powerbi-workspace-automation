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
    public class WorkspaceTriggers
    {
        private readonly IPowerBIService powerBIClient;

        public WorkspaceTriggers(IPowerBIService powerBIClient)
        {
            this.powerBIClient = powerBIClient;
        }

        [FunctionName("WorkspaceCreate")]
        public async Task<IActionResult> WorkspaceCreate(
            [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
            [CosmosDB(
                databaseName: "%cosmosDbName%",
                collectionName: "%subscriptionCollectionName%",
                ConnectionStringSetting = "cosmosDBConnection",
                Id = "{Query.id}",
                PartitionKey = "{Query.id}")]SubscriptionItem subscriptionItem,
            ILogger log)
        {

            log.LogInformation("WorkspaceCreate activated.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            var workspaceName = $"{subscriptionItem.WorkspacePrefix}-{data.workSpaceName}";
            var group = await powerBIClient.CreateGroupAsync(workspaceName);

            return new CreatedResult(group.Id.ToString(), group);
        }

        [FunctionName("WorkspaceList")]
        public async Task<IActionResult> WorkspaceList(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            [CosmosDB(
                databaseName: "%cosmosDbName%",
                collectionName: "%subscriptionCollectionName%",
                ConnectionStringSetting = "cosmosDBConnection",
                Id = "{Query.id}",
                PartitionKey = "{Query.id}")]SubscriptionItem subscriptionItem,
            ILogger log)
        {
            log.LogInformation("WorkspaceList activated.");
            var id = req.Query["id"];
            var groups = await powerBIClient.GetGroupsAsync();

            return new OkObjectResult(groups);
        }
    }
}

