using Microsoft.Graph;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IGraphService
    {
        Task<Group> GetAadSecurityGroup(string groupName);
    }
}