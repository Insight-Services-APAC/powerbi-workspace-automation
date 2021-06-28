using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Services;
using Microsoft.Extensions.DependencyInjection;

namespace Insight.PowerBI.Core
{
    public static class RegisterCoreServices
    {
        public static void AddPowerBICoreServices(this IServiceCollection services)
        {
            services.AddSingleton<IPowerBIService, PowerBIService>();
            services.AddSingleton<IAuthenticationService, AuthenticationService>();
            services.AddSingleton<ICosmosDbService, CosmosDbService>();
            services.AddSingleton<IGraphService, GraphService>();
            services.AddSingleton<IPowerBIETLOrchestration, PowerBIETLOrchestration>();
            services.AddSingleton<IActivityService, ActivityService>();
        }
    }
}
