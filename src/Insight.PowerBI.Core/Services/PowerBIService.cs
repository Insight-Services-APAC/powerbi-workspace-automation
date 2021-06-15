using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Insight.PowerBI.Core.Interfaces;
using Microsoft.Extensions.Logging;
using Microsoft.PowerBI.Api;
using Microsoft.PowerBI.Api.Models;
using Microsoft.Rest;

namespace Insight.PowerBI.Core.Services
{

    public class PowerBIService : IPowerBIService
    {
        private readonly IAuthenticationService authenticationService;
        private readonly ILogger<PowerBIService> logger;

        public PowerBIService(IAuthenticationService authenticationService, ILogger<PowerBIService> logger)
        {
            this.authenticationService = authenticationService;
            this.logger = logger;
        }

        private async Task<PowerBIClient> GetPowerBIClientAsync()
        {
            var token = await authenticationService.GetTokenCredentialsAsync();
            return new PowerBIClient(new Uri(authenticationService.ApiUrl), new TokenCredentials(token.AccessToken));
        }

        public async Task<IList<Group>> GetGroupsAsync()
        {
            var client = await GetPowerBIClientAsync();
            var groups = await client.Groups.GetGroupsAsAdminAsync(100, "users,reports,dashboards,datasets");
            return groups.Value;
        }

        public async Task<Group> CreateGroupAsync(string workspaceName, string aadGroupName = null)
        {
            try
            {
                var client = await GetPowerBIClientAsync();
                var request = new GroupCreationRequest { Name = workspaceName };
                var group = await client.Groups.CreateGroupAsync(request);
                logger.LogInformation($"Created group: {group.Id}");
                return group;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "CreateGroupAsync failed");
                throw;
            }
        }
    }
}
