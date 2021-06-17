using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface ICosmosDbService
    {
        Task<IList<T>> GetItemsAsync<T>(string containerId, string query = null);
        Task WriteItemsAsync<T>(string containerId, IList<T> items, Func<T, string> partitionFunc);
    }
}
