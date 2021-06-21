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
    public class WorkspaceExtractOrchestration : IWorkspaceExtractOrchestration
    {
        private readonly IPowerBIService powerBIService;
        private readonly ICosmosDbService cosmosDbService;
        private readonly CosmosDbOptions cosmosDbOptions;

        public WorkspaceExtractOrchestration(IPowerBIService powerBIService, ICosmosDbService cosmosDbService, IOptions<CosmosDbOptions> cosmosDbOptions)
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

            List<HSPPowerBIGroup> outputGroups = new List<HSPPowerBIGroup>();
            foreach (var s in subscriptions)
            {
                var foundGroups = groups
                    .Where(g => g.Name.StartsWith(s.WorkspacePrefix))
                    .Select(g => new HSPPowerBIGroup(s.WorkspacePrefix, g));
                outputGroups.AddRange(foundGroups);
            }

            await cosmosDbService.WriteItemsAsync(
                cosmosDbOptions.WorkspaceContainerName,
                outputGroups,
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

            await cosmosDbService.WriteItemsAsync(
                cosmosDbOptions.ActivitiesContainerName,
                items,
                (PowerBIActivity x) => x.id);

            return items;
        }
    }
}
