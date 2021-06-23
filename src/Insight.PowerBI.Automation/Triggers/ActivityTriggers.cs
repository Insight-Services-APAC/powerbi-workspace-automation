using Insight.PowerBI.Core.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace Insight.PBIAutomation.Triggers
{
    public class ActivityTriggers
    {
        private const string GetFromDateErrorSource = "GetFromDate";
        private readonly IActivityService activityService;

        public ActivityTriggers(IActivityService activityService)
        {
            this.activityService = activityService;
        }

        [FunctionName("WorkspaceActivities")]
        public async Task<IActionResult> GetWorkspaceActivitiesAsync(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            [CosmosDB(
                databaseName: "%cosmosDbName%",
                collectionName: "%SubscriptionContainerName%",
                ConnectionStringSetting = "CosmosDBConnection",
                Id = "{Query.id}",
                PartitionKey = "{Query.id}")]SubscriptionItem subscriptionItem,
            ILogger log)
        {
            try
            {
                DateTime dateFrom = GetFromDate(req);
                log.LogInformation("ActivityGet activated.");
                var result = await activityService.GetWorkspaceActivitiesAsync(subscriptionItem.WorkspacePrefix, dateFrom);
                return new OkObjectResult(result.Select(x => x.Payload));
            }
            catch (Exception ex)
            {
                if (ex.Source == GetFromDateErrorSource)
                {
                    return new BadRequestObjectResult(ex.Message);
                }
                else
                {
                    throw;
                }
            }
        }

        [FunctionName("Activities")]
        public async Task<IActionResult> GetActivitiesAsync(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
            ILogger log)
        {
            try
            {
                DateTime dateFrom = GetFromDate(req);
                log.LogInformation("ActivityGet activated.");
                var result = await activityService.GetActivitiesAsync(dateFrom);
                return new OkObjectResult(result.Select(x => x.Payload));
            }
            catch (Exception ex)
            {
                if (ex.Source == GetFromDateErrorSource)
                {
                    return new BadRequestObjectResult(ex.Message);
                }
                else
                {
                    throw;
                }
            }
        }
        private static DateTime GetFromDate(HttpRequest req)
        {
            var fromDateString = req.Query["from"].ToString();
            string error = string.Empty;
            DateTime fromDate = DateTime.UtcNow;
            if (string.IsNullOrEmpty(fromDateString))
            {
                error = "Must provide 'from' in query string";
            }
            else
            {
                if (!DateTime.TryParse(fromDateString, out fromDate))
                {
                    error = "Invalid date provided in 'from' parameter. Try 'yyyy-MM-ddTHH:mm:ssZ'";
                }
                else if (fromDate < DateTime.UtcNow.AddHours(-3 * 24))
                {
                    error = "'from' cannot be earlier than 72 hours";
                }
            }

            if (!string.IsNullOrEmpty(error))
            {
                throw new Exception(error) { Source = GetFromDateErrorSource };
            }

            return fromDate;
        }
    }
}
