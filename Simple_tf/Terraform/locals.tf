data "azurerm_client_config" "current" {}

data "azuread_service_principal" "current" {
  object_id = var.service_principal_id
}

data "azurerm_key_vault_secret" "default_secret" {
  name         = "DefaultConnection"
  key_vault_id = module.keyvault["{{env}}"].key_vault_id

  depends_on = [ module.keyvault ]
}

data "azurerm_subnet" "subnet" {
  for_each             = var.infra
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.vnet_resource_group_name
}

output "App_Insight_Connection_String_UI" {
  value = module.app_insights_ui["{{env}}"].connection_string
  sensitive = true
}

locals {
  tags = {
    CostCenter      = "20060000"
    Application     = "Product Delivery"
    BusinessUnit   = "First Databank, Inc"
    Environment     = "{{env}}"
    Product         = "PD Central"
    SupportTeam     = "FDB#BusinessSystems@fdbhealth.com"
  }

  DefaultConnection_versionless_id = data.azurerm_key_vault_secret.default_secret.versionless_id

  api_app_service_settings = try({
      "APPINSIGHTS_INSTRUMENTATIONKEY"                         = "${module.app_insights_api["{{env}}"].instrumentation_key}"
      "APPINSIGHTS_PROFILERFEATURE_VERSION"                    = "1.0.0"
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"                    = "1.0.0"
      "APPLICATIONINSIGHTS_CONNECTION_STRING"                  = "${module.app_insights_api["{{env}}"].connection_string}"
      "ApplicationInsightsAgent_EXTENSION_VERSION"             = "~2"
      "DiagnosticServices_EXTENSION_VERSION"                   = "~3"
      "InstrumentationEngine_EXTENSION_VERSION"                = "disabled"
      "SnapshotDebugger_EXTENSION_VERSION"                     = "disabled"
      "WEBSITE_ENABLE_SYNC_UPDATE_SITE"                        = "true"
      "XDT_MicrosoftApplicationInsights_BaseExtensions"        = "disabled"
      "XDT_MicrosoftApplicationInsights_Java"                  = "1"
      "XDT_MicrosoftApplicationInsights_Mode"                  = "recommended"
      "XDT_MicrosoftApplicationInsights_NodeJS"                = "1"
      "XDT_MicrosoftApplicationInsights_PreemptSdk"            = "disabled"
      "WEBSITE_RUN_FROM_PACKAGE"                               = "1"
    }, {})

  ui_app_service_settings = try({
      "ApiBasePath"                                            = "https://${module.app_service_api["{{env}}"].webapp_url}"
      "APPINSIGHTS_INSTRUMENTATIONKEY"                         = "${module.app_insights_ui["{{env}}"].instrumentation_key}"
      "APPINSIGHTS_PROFILERFEATURE_VERSION"                    = "1.0.0"
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"                    = "1.0.0"
      "APPLICATIONINSIGHTS_CONNECTION_STRING"                  = "${module.app_insights_ui["{{env}}"].connection_string}"
      "ApplicationInsightsAgent_EXTENSION_VERSION"             = "~2"
      "DiagnosticServices_EXTENSION_VERSION"                   = "~3"
      "InstrumentationEngine_EXTENSION_VERSION"                = "disabled"
      "SnapshotDebugger_EXTENSION_VERSION"                     = "disabled"
      "WEBSITE_ENABLE_SYNC_UPDATE_SITE"                        = "true"
      "XDT_MicrosoftApplicationInsights_BaseExtensions"        = "disabled"
      "XDT_MicrosoftApplicationInsights_Java"                  = "1"
      "XDT_MicrosoftApplicationInsights_Mode"                  = "recommended"
      "XDT_MicrosoftApplicationInsights_NodeJS"                = "1"
      "XDT_MicrosoftApplicationInsights_PreemptSdk"            = "disabled"
      "WEBSITE_RUN_FROM_PACKAGE"                               = "1"
    }, {})

  api_app_service_conn_string = try([
    {
      "name"                = "DefaultConnection"
      "type"                = "Custom"
      "value"               = "@Microsoft.KeyVault(VaultName=${module.keyvault["{{env}}"].key_vault_name};SecretName=DefaultConnection)"
    },
    {
      "name"                = "AppConfig"
      "type"                = "Custom"
      "value"               = "${module.app_configuration["{{env}}"].app_config_conn_string}"
    }
    ], [])

  app_configuration = [
    {
        key                 = "default_connection"
        type                = "vault"
        label               = ""
        vault_key_reference = "${local.DefaultConnection_versionless_id}"
    }
  ]

  api_app_service_identity   = ["${module.app_service_api["{{env}}"].webapp_identity.0.principal_id}"]
  app_configuration_identity = ["${module.app_configuration["{{env}}"].app_configuration_identity.0.principal_id}"]

  tenant_id = data.azurerm_client_config.current.tenant_id
  sp_object_id = data.azuread_service_principal.current.object_id

}