using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;
using Insight.PowerBI.Core;
using Microsoft.Extensions.Configuration;
using System;
using Microsoft.Azure.Cosmos.Fluent;
using Insight.PowerBI.Core.Interfaces;
using Insight.PowerBI.Core.Services;

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
            builder.Services.AddTransient<IPowerBIService, PowerBIService>();
            builder.Services.AddSingleton<IAuthenticationService, AuthenticationService>();
            builder.Services.AddSingleton<ICosmosDbService, CosmosDbService>();
            builder.Services.AddSingleton(s =>
            {
                var connectionString = context.Configuration.GetValue<string>("cosmosDBConnection");
                return new CosmosClientBuilder(connectionString).Build();
            });
            builder.Services.AddLogging();
        }
    }
}