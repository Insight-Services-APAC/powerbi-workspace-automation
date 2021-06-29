using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Options;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
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


        public async Task<IList<T>> CreateItemsAsync<T>(string containerId, IList<T> items, Func<T, string> partitionFunc)
        {
            try
            {
                var container = cosmosClient.GetContainer(DatabaseId, containerId);
                List<T> responseItems = new List<T>();
                foreach (var item in items)
                {
                    var response = await container.UpsertItemAsync<T>(item, new PartitionKey(partitionFunc(item)));
                    responseItems.Add(response.Resource);
                }
                return responseItems;
            }
            catch (Exception ex)
            {
                throw new Exception("CosmosDbUpsertFailed", ex);
            }
        }

        public async Task<T> CreateItemAsync<T>(string containerId, T item, Func<T, string> partitionFunc)
        {
            try
            {
                var container = cosmosClient.GetContainer(DatabaseId, containerId);
                var response = await container.CreateItemAsync<T>(item, new PartitionKey(partitionFunc(item)));
                return response.Resource;
            }
            catch (Exception ex)
            {
                throw new Exception("CosmosDbInsertFailed", ex);
            }
        }

        public async Task<IList<T>> GetItemsAsync<T>(string containerId, QueryDefinition query)
        {
            return await GetItemsInternalAsync<T>(containerId, query);
        }

        public async Task<IList<T>> GetItemsAsync<T>(string containerId, string queryString)
        {
            if (string.IsNullOrEmpty(queryString))
                queryString = "SELECT * FROM c";
            var query = new QueryDefinition(queryString);
            return await GetItemsInternalAsync<T>(containerId, query);
        }

        private async Task<IList<T>> GetItemsInternalAsync<T>(string containerId, QueryDefinition query)
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
