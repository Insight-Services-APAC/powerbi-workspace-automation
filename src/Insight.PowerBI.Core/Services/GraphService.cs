using Insight.PowerBI.Core.Interfaces;
using Microsoft.Graph;
using Microsoft.Graph.Auth;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Services
{
    public class GraphService : IGraphService
    {
        private readonly IAuthenticationService authenticationService;
        private GraphServiceClient client;

        public GraphService(IAuthenticationService authenticationService)
        {
            this.authenticationService = authenticationService;
            var confidentialClient = authenticationService.GetConfidentialClient();
            client = new GraphServiceClient(new ClientCredentialProvider(confidentialClient));
        }

        public async Task<Group> GetAadSecurityGroup(string groupName)
        {
            var result = await client.Groups.Request().Filter($"displayName eq '{groupName}'").GetAsync();
            return result.FirstOrDefault();
        }
    }
}
