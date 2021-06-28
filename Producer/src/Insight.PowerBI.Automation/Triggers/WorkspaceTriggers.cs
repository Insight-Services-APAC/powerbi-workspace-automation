using Insight.PowerBI.Core.Exceptions;
using Insight.PowerBI.Core.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Insight.PBIAutomation.Triggers
{
    public class WorkspaceTriggers
    {
        private readonly IPowerBIService powerBIClient;

        public WorkspaceTriggers(IPowerBIService powerBIClient)
        {
            this.powerBIClient = powerBIClient;
        }

        [FunctionName("Workspace")]
        public async Task<IActionResult> WorkspaceAsync(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", "put", Route = null)] HttpRequest req,
            [CosmosDB(
                databaseName: "%cosmosDbName%",
                collectionName: "%SubscriptionContainerName%",
                ConnectionStringSetting = "CosmosDBConnection",
                Id = "{Query.id}",
                PartitionKey = "{Query.id}")]SubscriptionItem subscriptionItem,
            ILogger log)
        {

            log.LogInformation("WorkspaceAsync activated.");
            try
            {
                IActionResult result = new OkResult();
                string workspaceName = await GetWorkspaceNameFromRequestAsync(req, subscriptionItem);
                
                switch (req.Method)
                {
                    case "GET":
                        result = await GetWorkspaceAsync(workspaceName);
                        break;
                    case "POST":
                        result = await CreateWorkspaceAsync(subscriptionItem, workspaceName);
                        break;
                    case "PUT":
                        result = await UpdateWorkspaceAsync(subscriptionItem, workspaceName);
                        break;
                }
                return result;
            }
            catch (PowerBIException ex)
            {
                return new BadRequestObjectResult(new { Message = ex.Message });
            }
            catch
            {
                throw;
            }
        }

        private static async Task<string> GetWorkspaceNameFromRequestAsync(HttpRequest req, SubscriptionItem subscriptionItem)
        {
            if (req.Method == "GET")
            {
                return req.Query["name"].ToString();
            }
            else
            {
                string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
                dynamic data = JsonConvert.DeserializeObject(requestBody);
                if (data != null && subscriptionItem != null)
                    return $"{subscriptionItem.WorkspacePrefix}-{data.workSpaceName}";
                else
                    return string.Empty;
            }
        }

        private async Task<IActionResult> UpdateWorkspaceAsync(SubscriptionItem subscriptionItem, string workspaceName)
        {
            await powerBIClient.UpdateGroupAsync(workspaceName, subscriptionItem.AdminSecurityGroup);
            return new OkResult();
        }

        private async Task<IActionResult> CreateWorkspaceAsync(SubscriptionItem subscriptionItem, string workspaceName)
        {
            var group = await powerBIClient.CreateGroupAsync(workspaceName, subscriptionItem.AdminSecurityGroup);
            return new CreatedResult(group.Id.ToString(), group);
        }

        private async Task<IActionResult> GetWorkspaceAsync(string workspaceName)
        {
            if (string.IsNullOrEmpty(workspaceName))
                return new BadRequestObjectResult(new { error = "'name' must be a valid workspace name" });

            var groups = await powerBIClient.GetGroupAsync(workspaceName);

            return new OkObjectResult(groups);
        }

        [FunctionName("Workspaces")]
        public async Task<IActionResult> WorkspaceList(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            [CosmosDB(
                databaseName: "%cosmosDbName%",
                collectionName: "%SubscriptionContainerName%",
                ConnectionStringSetting = "CosmosDBConnection",
                Id = "{Query.id}",
                PartitionKey = "{Query.id}")]SubscriptionItem subscriptionItem,
            ILogger log)
        {
            log.LogInformation("WorkspaceList activated.");
            var groups = await powerBIClient.GetGroupsAllExpandedAsync();
            var result = groups.Where(x => x.Name.StartsWith(subscriptionItem.WorkspacePrefix)).ToList();

            return new OkObjectResult(result);
        }
    }
}

