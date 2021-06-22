using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.PowerBI.Api.Models;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IPowerBIService
    {
        Task<IList<Group>> GetGroupAsync(string workspaceName);
        Task<Group> CreateGroupAsync(string workspaceName, string aadGroupName = null);
        Task UpdateGroupAsync(string workspaceName, string aadGroupName);
        Task<IList<Group>> GetGroupsAllExpandedAsync();
        Task<IList<object>> GetActivityEventsAsync(DateTime? defaultDate = null);
    }
}
