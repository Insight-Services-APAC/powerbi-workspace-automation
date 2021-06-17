using System.Collections.Generic;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IWorkspaceExtractOrchestration
    {
        Task<IList<object>> ActivitiesAsync();
        Task WorkspaceETLAsync();
    }
}