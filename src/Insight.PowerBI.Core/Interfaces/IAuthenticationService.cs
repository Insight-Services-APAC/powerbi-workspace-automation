using Microsoft.Identity.Client;
using System.Threading.Tasks;

namespace Insight.PowerBI.Core.Interfaces
{
    public interface IAuthenticationService
    {
        string ApiUrl { get; }
        string Scope { get; }

        IConfidentialClientApplication GetConfidentialClient();
        Task<AuthenticationResult> GetTokenCredentialsAsync();
    }
}
