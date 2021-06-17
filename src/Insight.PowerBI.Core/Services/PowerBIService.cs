using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using Insight.PowerBI.Core.Exceptions;
using Insight.PowerBI.Core.Interfaces;
using Microsoft.Extensions.Logging;
using Microsoft.PowerBI.Api;
using Microsoft.PowerBI.Api.Models;
using Microsoft.Rest;
using Newtonsoft.Json;

namespace Insight.PowerBI.Core.Services
{

    public class PowerBIService : IPowerBIService
    {
        private const string PowerBIUnknownError = "PowerBIUnknownError";
        private readonly IAuthenticationService authenticationService;
        private readonly IGraphService graphService;
        private readonly ILogger<PowerBIService> logger;
        private PowerBIClient _client;

        public PowerBIService(IAuthenticationService authenticationService, IGraphService graphService, ILogger<PowerBIService> logger)
        {
            this.authenticationService = authenticationService;
            this.graphService = graphService;
            this.logger = logger;
        }

        private async Task<PowerBIClient> GetPowerBIClientAsync()
        {
            if (_client == null)
            {
                var token = await authenticationService.GetTokenCredentialsAsync();
                _client = new PowerBIClient(new Uri(authenticationService.ApiUrl), new TokenCredentials(token.AccessToken));
            }
            return _client;
        }

        public async Task<IList<Group>> GetGroupsAllExpandedAsync()
        {
            try
            {
                var client = await GetPowerBIClientAsync();
                var groups = await client.Groups.GetGroupsAsAdminAsync(100, "users,reports,dashboards,datasets");
                return groups.Value;
            }
            catch (HttpOperationException ex)
            {
                throw HandleHttpOperationException(ex);
            }
            catch
            {
                throw;
            }
        }

        public async Task<IList<Group>> GetGroupAsync(string workspaceName)
        {
            try
            {
                var client = await GetPowerBIClientAsync();
                var groups = await client.Groups.GetGroupsAsync($"name eq '{workspaceName}'");
                return groups.Value;
            }
            catch (HttpOperationException ex)
            {
                throw HandleHttpOperationException(ex);
            }
            catch
            {
                throw;
            }
        }

        public async Task<Group> CreateGroupAsync(string workspaceName, string aadGroupName = null)
        {
            try
            {
                Microsoft.Graph.Group adgroup = await GetAadSecurityGroup(aadGroupName);
                var client = await GetPowerBIClientAsync();
                var request = new GroupCreationRequest { Name = workspaceName };
                var group = await client.Groups.CreateGroupAsync(request);
                logger.LogInformation($"Created group: {group.Id}");
                await SetPowerBIGroupAdmin(group.Id, aadGroupName, adgroup.Id, client);
                return group;
            }
            catch (HttpOperationException ex)
            {
                throw HandleHttpOperationException(ex);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "CreateGroupAsync failed");
                throw new Exception(PowerBIUnknownError, ex);
            }
        }

        public async Task<Group> AddGroupAdmin(Group group, string aadGroupName)
        {
            try
            {
                Microsoft.Graph.Group adgroup = await GetAadSecurityGroup(aadGroupName);
                var client = await GetPowerBIClientAsync();
                await SetPowerBIGroupAdmin(group.Id, aadGroupName, adgroup.Id, client);
                return group;
            }
            catch (HttpOperationException ex)
            {
                throw HandleHttpOperationException(ex);
            }
            catch
            {
                throw;
            }
        }

        private async Task SetPowerBIGroupAdmin(Guid groupId, string aadGroupName, string objectId, PowerBIClient client)
        {
            await client.Groups.AddGroupUserAsync(groupId, new GroupUser
            {
                PrincipalType = PrincipalType.Group,
                GroupUserAccessRight = GroupUserAccessRight.Admin,
                Identifier = objectId
            });
            logger.LogInformation($"Added {objectId} as admin to group: {groupId}");
        }

        private async Task<Microsoft.Graph.Group> GetAadSecurityGroup(string aadGroupName)
        {
            var adgroup = await graphService.GetAadSecurityGroup(aadGroupName);
            if (adgroup == null)
                throw new PowerBIException("GraphApiGroupNotFound");
            return adgroup;
        }

        public async Task UpdateGroupAsync(string workspaceName, string aadGroupName)
        {
            try
            {
                var groups = await GetGroupAsync(workspaceName);
                var group = groups.FirstOrDefault();
                if (group == null)
                    throw new Exception("PowerBiWorkspaceNotFound");
                await AddGroupAdmin(group, aadGroupName);
            }
            catch (HttpOperationException ex)
            {
                throw HandleHttpOperationException(ex);
            }
            catch
            {
                throw;
            }

        }

        private Exception HandleHttpOperationException(HttpOperationException ex, [CallerMemberName] string memberName = "PowerBIService")
        {
            logger.LogError(ex, $"{memberName} failed");
            dynamic errorResponse = JsonConvert.DeserializeObject(ex.Response.Content);
            string message = errorResponse?.error?.code ?? PowerBIUnknownError;
            return new PowerBIException(message, ex);
        }
    }
}
