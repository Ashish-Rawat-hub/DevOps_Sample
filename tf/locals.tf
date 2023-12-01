data "azurerm_client_config" "current" {}

data "azuread_service_principal" "current" {
  display_name = var.principal_display_name
}

locals {

  tags = {}
  key_vault_modules_secrets = []
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azuread_service_principal.current.object_id

  /* availability_function_settings = try({
    "AAD_CLIENT_ID"                                       = "1e71641b-7930-442c-9bbc-b80644c9e738"
    "AAD_CLIENT_SECRET"                                   = "@Microsoft.KeyVault(VaultName=fdb-{{env}}-{{secondary_postfix}};SecretName=AAD-CLIENT-SECRET)"
    "AppInsights-ApplicationID"                           = "2a3b1774-d5fe-4c34-9af3-3adc89c01dd6"
    "AppInsightsConnectionString"                         = "InstrumentationKey=c5af286e-458c-4af2-a1a4-34a815ce2756;IngestionEndpoint=https://northcentralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://northcentralus.livediagnostics.monitor.azure.com/"
    "EAST_US_KEYVAULT_NAME"                               = "{{prefix}}-{{env_short}}-kv-{{postfix}}-2O"
    "EnvironmentName"                                     = "{{env}}"
    "FDB_SMTP_PASSWORD"                                   = "@Microsoft.KeyVault(VaultName=fdb-{{env}}-{{secondary_postfix}};SecretName=FDB-SMTP-PASSWORD)"
    "FDB_SMTP_USERNAME"                                   = "FDBVela@fdbhealth.com"
    "FDB_SUPPORT_EMAIL"                                   = "FDBVela@fdbhealth.com"
    "FUNCTIONS_WORKER_RUNTIME"                            = "dotnet"
    "SMTP_HOST"                                           = "Relay.hearst.com"
    "SMTP_PORT"                                           = "25"
    "SUPPORT_EMAIL"                                       = "sunil.singh@altysys.com"
    "TenantID"                                            = "a84894e7-87c5-40e3-9783-320d0334b3cc"
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE"                     = "true"
    "keyName"                                             = "TestKey"
    "keyVaultName"                                        = "{{prefix}}-{{env_short}}-kv-{{postfix}}-2O"
  }, {}) */

}
