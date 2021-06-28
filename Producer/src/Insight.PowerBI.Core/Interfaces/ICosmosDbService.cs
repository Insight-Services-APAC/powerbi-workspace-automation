using Microsoft.Azure.Cosmos;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface ICosmosDbService
    {
        Task<IList<T>> GetItemsAsync<T>(string containerId, string query = null);
        Task<IList<T>> CreateItemsAsync<T>(string containerId, IList<T> items, Func<T, string> partitionFunc);
        Task<T> CreateItemAsync<T>(string containerId, T items, Func<T, string> partitionFunc);
        Task<IList<T>> GetItemsAsync<T>(string containerId, QueryDefinition query);
    }
}
