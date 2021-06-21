using System;
using System.Collections.Generic;
using System.Text;

namespace Insight.PowerBI.Core.Models
{
    public class PowerBIActivityPayload
    {
        public string Id { get; set; }
        public DateTime CreationTime { get; set; }
        public string Operation { get; set; }
        public string OrganizationId { get; set; }
        public string UserKey { get; set; }
        public string Activity { get; set; }
        public string Workload { get; set; }
        public string UserId { get; set; }
        public string ClientIP { get; set; }
    }
}
