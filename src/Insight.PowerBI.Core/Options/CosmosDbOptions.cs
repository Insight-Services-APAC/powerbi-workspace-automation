using System;
using System.Collections.Generic;
using System.Text;

namespace Insight.PowerBI.Core.Options
{
    public class CosmosDbOptions
    {
        public string CosmosDbName { get; set; }
        public string SubscriptionContainerName { get; set; }
        public string WorkspaceContainerName { get; set; }
        public string ActivitiesContainerName{ get; set; }
        public string CosmosDBConnection { get; set; }
    }
}
