using Insight.PBIAutomation;
using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Models;
using Insight.PowerBI.Core.Options;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Services
{
    public class PowerBIETLOrchestration : IPowerBIETLOrchestration
    {
        private const string DefaultWorkspacePartitionKey = "default";
        private readonly IPowerBIService powerBIService;
        private readonly ICosmosDbService cosmosDbService;
        private readonly CosmosDbOptions cosmosDbOptions;

        public PowerBIETLOrchestration(IPowerBIService powerBIService, ICosmosDbService cosmosDbService, IOptions<CosmosDbOptions> cosmosDbOptions)
        {
            this.powerBIService = powerBIService;
            this.cosmosDbService = cosmosDbService;
            this.cosmosDbOptions = cosmosDbOptions.Value;
        }

        public async Task WorkspacesAsync()
        {
            var groups = await powerBIService.GetGroupsAllExpandedAsync();
            var subscriptions = await cosmosDbService.
                GetItemsAsync<SubscriptionItem>(cosmosDbOptions.SubscriptionContainerName);

            Func<Microsoft.PowerBI.Api.Models.Group, IList<SubscriptionItem>, string> GetWorkspacePrefix = (group, subs) => 
                subs.FirstOrDefault(s => group.Name.StartsWith(s.WorkspacePrefix))?.WorkspacePrefix ?? DefaultWorkspacePartitionKey;

            var result = groups.Select(x => new HSPPowerBIGroup(GetWorkspacePrefix(x, subscriptions), x)).ToList();

            await cosmosDbService.CreateItemsAsync(
                cosmosDbOptions.WorkspaceContainerName,
                result,
                (HSPPowerBIGroup x) => x.HSPName);
        }

        public async Task<IList<PowerBIActivity>> ActivitiesAsync(DateTime? defaultDate = null)
        {
            var activities = await powerBIService.GetActivityEventsAsync(defaultDate);

            var items = activities.Select(x => new PowerBIActivity
            {
                id = JObject.Parse(x.ToString())["Id"].ToString(),
                Payload = JsonConvert.DeserializeObject(x.ToString())
            }).ToList();

            await cosmosDbService.CreateItemsAsync(
                cosmosDbOptions.ActivitiesContainerName,
                items,
                (PowerBIActivity x) => x.id);

            return items;
        }
    }
}
