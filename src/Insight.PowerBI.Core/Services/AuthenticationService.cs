using Insight.PowerBI.Core.Interfaces;
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

        private IConfidentialClientApplication GetConfidentialClient()
        {
            return ConfidentialClientApplicationBuilder.Create(config.ClientId)
                   .WithClientSecret(config.ClientSecret)
                   .WithAuthority(new Uri(config.Authority))
                   .Build();
        }

        public async Task<AuthenticationResult> GetTokenCredentialsAsync()
        {
            return await GetConfidentialClient().AcquireTokenForClient(new string[] { config.Scope }).ExecuteAsync();
        }
    }
}
