azd env get-values > .env
$environmentName = $env:AZURE_ENV_NAME
$location = $env:AZURE_LOCATION
# Sending statistics to the Azure Storage account tablen no PII inforfamtion will be send. If you do not wish to send statistics, please comment out this line.


$webhookUrl = "https://8116ebc5-9750-4a45-bb68-3623eef692f3.webhook.ne.azure-automation.net/webhooks?token=ZEwDwUSa225CZVgKPQ7ZDDe6K%2f8k9sMl2ou1FJlYpMA%3d"

$deploymentData = @{
    Deployment = "AZD-WIN11-DEV-PC-DOCKER"
    location = $location
    environmentName =$environmentName
    Machine = $env:AZUREPS_HOST_ENVIRONMENT
    CommitHash = (git rev-parse HEAD)
  } | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $deploymentData -ContentType "application/json"
Write-Output $environmentName
Write-Output "Stats Tracked"

