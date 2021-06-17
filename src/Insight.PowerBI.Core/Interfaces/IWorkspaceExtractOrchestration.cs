using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IWorkspaceExtractOrchestration
    {
        Task WorkspaceETLAsync();
    }
}