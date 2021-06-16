using Insight.PowerBI.Core.Interfaces;
using Microsoft.Azure.Cosmos;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Services
{

    public class CosmosDbService : ICosmosDbService
    {
        private const string DatabaseId = "PBIAutomate";
        private const string ContainerId = "Subscriptions";
        private readonly CosmosClient cosmosClient;

        public CosmosDbService(CosmosClient cosmosClient)
        {
            this.cosmosClient = cosmosClient;
        }

        public void WriteItem<T>(IList<T> items)
        {
            var container = cosmosClient.GetContainer(DatabaseId, ContainerId);
            foreach (var item in items)
                container.CreateItemAsync(item);

        }

        public async Task GetItemsAsync()
        {
            var container = cosmosClient.GetContainer(DatabaseId, ContainerId);
            using (var iterator = container.GetItemQueryIterator<dynamic>())
            {
                while (iterator.HasMoreResults)
                {
                    var response = await iterator.ReadNextAsync();
                    foreach (var item in response)
                    {
                        Console.WriteLine(item);
                    }
                }
            }
        }
    }
}
