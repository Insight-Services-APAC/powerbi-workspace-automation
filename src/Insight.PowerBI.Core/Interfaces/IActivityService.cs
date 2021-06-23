using Insight.PowerBI.Core.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IActivityService
    {
        Task<IList<PowerBIActivity>> GetActivitiesAsync(string workspaceName, DateTime dateFrom);
    }
}