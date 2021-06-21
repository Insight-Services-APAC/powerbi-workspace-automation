using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using System;
using Microsoft.Azure.Cosmos.Fluent;
using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Services;
using Insight.PowerBI.Core.Options;

[assembly: FunctionsStartup(typeof(Insight.PowerBI.Automation.Startup))]
namespace Insight.PowerBI.Automation
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            Console.WriteLine("Booting up.");
            var context = builder.GetContext();
            builder.Services.AddOptions<AuthenticationConfig>().Configure<IConfiguration>((settings, configuration) => { 
                configuration.GetSection("AuthenticationConfig").Bind(settings);
            });
            builder.Services.AddOptions<CosmosDbOptions>().Configure<IConfiguration>((settings, configuration) => {
                settings.CosmosDBConnection = configuration.GetValue<string>("CosmosDBConnection");
                settings.CosmosDbName = configuration.GetValue<string>("CosmosDbName");
                settings.SubscriptionContainerName= configuration.GetValue<string>("SubscriptionContainerName");
                settings.WorkspaceContainerName = configuration.GetValue<string>("WorkspaceContainerName");
                settings.ActivitiesContainerName = configuration.GetValue<string>("ActivitiesContainerName");
            });
            builder.Services.AddHttpClient();
            builder.Services.AddSingleton<IPowerBIService, PowerBIService>();
            builder.Services.AddSingleton<IAuthenticationService, AuthenticationService>();
            builder.Services.AddSingleton<ICosmosDbService, CosmosDbService>();
            builder.Services.AddSingleton<IGraphService, GraphService>();
            builder.Services.AddSingleton<IPowerBIETLOrchestration, PowerBIETLOrchestration>();
            builder.Services.AddSingleton(s =>
            {
                var connectionString = context.Configuration.GetValue<string>("CosmosDBConnection");
                return new CosmosClientBuilder(connectionString).Build();
            });
            builder.Services.AddLogging();
        }
    }
}