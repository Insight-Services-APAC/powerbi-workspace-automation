using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
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
        private readonly HttpClient httpClient;
        private PowerBIClient _client;

        public PowerBIService(IAuthenticationService authenticationService, IGraphService graphService, ILogger<PowerBIService> logger, HttpClient httpClient)
        {
            this.authenticationService = authenticationService;
            this.graphService = graphService;
            this.logger = logger;
            this.httpClient = httpClient;
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
                List<Group> groups = new List<Group>();
                const int top = 1000;
                int skip = 0;
                var response = await client.Groups.GetGroupsAsAdminAsync(top, "users,reports,dashboards,datasets", "state eq 'Active'");
                groups.AddRange(response.Value);

                while (response.Value.Count == top)
                {
                    skip += top;
                    response = await client.Groups.GetGroupsAsAdminAsync(top, "users,reports,dashboards,datasets", "state eq 'Active'", skip);
                    groups.AddRange(response.Value);
                }
                return groups;
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

        public async Task<IList<object>> GetActivityEventsAsync(DateTime? defaultDate = null)
        {
            try
            {
                var activityDate = (defaultDate ?? DateTime.UtcNow);

                var startDate = activityDate.ToString("yyyy-MM-ddT00:00:00");
                var endDate = activityDate.ToString("yyyy-MM-ddT23:59:59");
                var client = await GetPowerBIClientAsync();

                var response = await client.Admin.GetActivityEventsAsync(startDateTime: $"'{startDate}'", endDateTime: $"'{endDate}'");
                return await GetActivityEventsAsync(response);
            }
            catch (HttpOperationException ex)
            {
                Debug.WriteLine(ex.Request.RequestUri);
                Debug.WriteLine(ex.Response.Content);
                throw HandleHttpOperationException(ex);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, $"GetActivityEventsAsync failed");
                throw;
            }

        }

        private async Task<IList<object>> GetActivityEventsAsync(ActivityEventResponse response)
        {
            List<object> activities = new List<object>();
            activities.AddRange(response.ActivityEventEntities);
            string accessToken = null;
            if (response.ContinuationToken != null)
            {
                accessToken = (await authenticationService.GetTokenCredentialsAsync()).AccessToken;
                httpClient.DefaultRequestHeaders.Remove("Authorization");
                httpClient.DefaultRequestHeaders.Add("Authorization", $"Bearer {accessToken}");
            }
            while (response.ContinuationToken != null)
            {
                var httpResponse = await httpClient.GetAsync(response.ContinuationUri);
                var responseContent = await httpResponse.Content.ReadAsStringAsync();
                response = JsonConvert.DeserializeObject<ActivityEventResponse>(responseContent);
                if (response.ActivityEventEntities != null)
                {
                    activities.AddRange(response.ActivityEventEntities);
                }
            }
            return activities;
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
