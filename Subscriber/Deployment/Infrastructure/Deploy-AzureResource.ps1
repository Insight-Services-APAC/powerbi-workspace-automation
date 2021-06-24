
# Parameter help description
Param(
    [Parameter(Mandatory)]
    [ValidateSet("Development","Production")]
    [string]
    $Environment = "Development"
)

Set-Location '.\.\Deployment\Infrastructure'

Write-Host "Retrieving deployment variables for: $Environment"
[Environment]::SetEnvironmentVariable("ENVIRONMENT_NAME", $Environment)
. .\Config\PushEnvFileIntoVariables.ps1
ParseEnvFile("$env:ENVIRONMENT_NAME")

if ($env:EnvOpts_CD_Enable -eq "True")
{

##FOR MANUAL EXECUTION INLCUDE THIS STEP, OR RUN THIS PRIOR TO EXECUTING THIS SCRIPT
#az login --service-principal -u http://AdsGFDeploySPw -p .p-z49LagOf8zLA1RT3~ej.G65Rl~5A5_C --tenant $env:EnvOpts_CD_ResourceGroup_TenantId

    Write-Host "Starting CD.."

    #Invoke-Expression -Command  ".\Steps\CD_Deploy_VNet.ps1"

    #Invoke-Expression -Command  ".\Steps\CD_Deploy_KeyVault.ps1"

    #Invoke-Expression -Command  ".\Steps\CD_Deploy_DataFactory.ps1"

    #Invoke-Expression -Command  ".\Steps\CD_Deploy_ADLS.ps1"

    #Invoke-Expression -Command  ".\Steps\CD_Deploy_SQLServer.ps1"

    #Invoke-Expression -Command  ".\Steps\CD_Deploy_SQLDatabase.ps1"

    Write-Host "Finishing CD.."

}
