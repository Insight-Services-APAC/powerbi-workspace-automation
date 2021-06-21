using Insight.PowerBI.Core.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IPowerBIETLOrchestration
    {
        Task<IList<PowerBIActivity>> ActivitiesAsync(DateTime? defaultDate = null);
        Task WorkspacesAsync();
    }
}