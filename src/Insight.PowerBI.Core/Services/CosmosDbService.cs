using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Models;
using Insight.PowerBI.Core.Options;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Services
{

    public class CosmosDbService : ICosmosDbService
    {
        private string DatabaseId => options.CosmosDbName;
        private readonly CosmosClient cosmosClient;
        private readonly ILogger<CosmosDbService> logger;
        private readonly CosmosDbOptions options;

        public CosmosDbService(
            CosmosClient cosmosClient, 
            IOptions<CosmosDbOptions> options, 
            ILogger<CosmosDbService> logger)
        {
            this.cosmosClient = cosmosClient;
            this.logger = logger;
            this.options = options.Value;
        }


        public async Task WriteItemsAsync<T>(string containerId, IList<T> items, Func<T, string> partitionFunc)
        {
            try
            {
                var container = cosmosClient.GetContainer(DatabaseId, containerId);
                foreach (var item in items)
                {
                    await container.UpsertItemAsync<T>(item, new PartitionKey(partitionFunc(item)));
                }
            }
            catch (Exception ex)
            {
                throw new Exception("CosmosDbUpsertFailed", ex);
            }
        }

        public async Task<IList<T>> GetItemsAsync<T>(string containerId, string query = null)
        {
            var container = cosmosClient.GetContainer(DatabaseId, containerId);
            var result = new List<T>();
            using (var iterator = container.GetItemQueryIterator<T>(query))
            {
                while (iterator.HasMoreResults)
                {
                    var response = await iterator.ReadNextAsync();
                    logger.LogInformation($"Get items: {response.RequestCharge}");
                    result.AddRange(response);
                }
            }
            return result;
        }
    }
}
