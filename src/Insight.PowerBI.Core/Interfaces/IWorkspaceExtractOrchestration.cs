using Insight.PowerBI.Core.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IWorkspaceExtractOrchestration
    {
        Task<IList<PowerBIActivity>> ActivitiesAsync(DateTime? defaultDate = null);
        Task WorkspaceETLAsync();
    }
}