using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace Insight.PowerBI.Core.Models
{
    public class SubscriptionItemRequest
    {
        [RegularExpression("[a-zA-Z0-9][-a-zA-Z0-9]+")]
        public string id { get; set; }
        public string AdminSecurityGroup { get; set; }
        public string DepartmentName { get; set; }
        public string WorkspacePrefix { get; set; }
    }
}
