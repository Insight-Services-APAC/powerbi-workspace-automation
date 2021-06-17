using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace Insight.PowerBI.Core.Options
{
    public class AuthenticationConfig
    {
        public string ClientId { get; set; }
        public string ClientSecret { get; set; }
        public string Tenant { get; set; }
        public string ApiUrl { get; set; } = "https://api.powerbi.com";
        public string Scope { get; set; } = "https://analysis.windows.net/powerbi/api/.default";
        public string Instance { get; set; } = "https://login.microsoftonline.com/{0}";
        public string Authority
        {
            get
            {
                return string.Format(CultureInfo.InvariantCulture, Instance, Tenant);
            }
        }
    }
}
