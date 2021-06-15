using System.Collections.Generic;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface ICosmosDbService
    {
        Task GetItemsAsync();
        void WriteItem<T>(IList<T> items);
    }
}
