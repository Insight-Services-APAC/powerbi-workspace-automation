using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.PowerBI.Api.Models;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IPowerBIService
    {
        Task<IList<Group>> GetGroupsAsync();
        Task<Group> CreateGroupAsync(string workspaceName, string aadGroupName = null);
    }
}
