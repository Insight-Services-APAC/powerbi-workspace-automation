using Microsoft.PowerBI.Api.Models;
using System.Text.Json.Serialization;

namespace Insight.PowerBI.Core.Models
{
    public class HSPPowerBIGroup
    {
        public string id => Group.Id.ToString();

        [JsonPropertyName("HSPName")]
        public string HSPName { get; set; }
        public Group Group { get; set; }

        public HSPPowerBIGroup(string HSPName, Group group)
        {
            this.HSPName = HSPName;
            Group = group;
        }

    }
}
