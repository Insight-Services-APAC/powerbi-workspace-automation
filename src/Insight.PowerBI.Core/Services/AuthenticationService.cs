using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Options;
using Microsoft.Extensions.Options;
using Microsoft.Identity.Client;
using System;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Services
{

    public class AuthenticationService : IAuthenticationService
    {
        private readonly AuthenticationConfig config;

        public string ApiUrl => config.ApiUrl;
        public string Scope => config.Scope;

        public AuthenticationService(IOptions<AuthenticationConfig> config)
        {
            this.config = config.Value;
        }

        private IConfidentialClientApplication GetPowerBIConfidentialClient()
        {
            return ConfidentialClientApplicationBuilder
                .Create(config.ClientId)
                .WithClientSecret(config.ClientSecret)
                .WithAuthority(new Uri(config.Authority))
                .Build();
        }

        public IConfidentialClientApplication GetConfidentialClient()
        {
            return ConfidentialClientApplicationBuilder
                .Create(config.ClientId)
                .WithClientSecret(config.ClientSecret)
                .WithTenantId(config.Tenant)
                .Build();
        }

        public async Task<AuthenticationResult> GetTokenCredentialsAsync()
        {
            return await GetPowerBIConfidentialClient().AcquireTokenForClient(new string[] { config.Scope }).ExecuteAsync();
        }
    }
}
