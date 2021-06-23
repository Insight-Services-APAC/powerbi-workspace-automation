using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Models;
using Insight.PowerBI.Core.Options;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Services
{
    public class ActivityService : IActivityService
    {
        private readonly ICosmosDbService cosmosDbService;
        private readonly CosmosDbOptions option;

        public ActivityService(ICosmosDbService cosmosDbService, IOptions<CosmosDbOptions> options)
        {
            this.cosmosDbService = cosmosDbService;
            this.option = options.Value;
        }

        public async Task<IList<PowerBIActivity>> GetActivitiesAsync(string workspaceName, DateTime dateFrom)
        {
            string queryString = "SELECT * FROM c WHERE STARTSWITH(c.Payload.WorkSpaceName, '@workspaceName') AND c.Payload.CreationTime > @dateFrom";
            QueryDefinition query = new QueryDefinition(queryString)
                .WithParameter("@workspaceName", workspaceName)
                .WithParameter("@dateFrom", dateFrom.ToString("u"));

            return await cosmosDbService.GetItemsAsync<PowerBIActivity>(option.ActivitiesContainerName, query);
        }
    }
}
