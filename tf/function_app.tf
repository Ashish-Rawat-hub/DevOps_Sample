locals {
  
  be_function_app_app_settings = try({
    "APPINSIGHTS_INSTRUMENTATIONKEY" = local.function_app_insight_instrumentation_key
  }, {})

  ip_restriction = [
        {
          name                      = "Apim-IP"
          priority                  = 110
          ip_address               = "${join(",", local.api_management_public_ip)}/32"
          action                    = "Allow"
        }
    ]
  
  function_app_insight_instrumentation_key = try(data.azurerm_application_insights.be_app_insights["{{env}}"].instrumentation_key, "")
  api_management_public_ip = try(data.azurerm_api_management.be_apim["{{env}}"].public_ip_addresses, [])
}

##Adding shared Application Insights as data source
data "azurerm_application_insights" "be_app_insights" {
  for_each            = var.function_apps
  name                = each.value.data_source.app_insight_name
  resource_group_name = each.value.main_rg_name
}

##Adding shared API Management as data source
data "azurerm_api_management" "be_apim" {
  for_each            = var.function_apps
  name                = each.value.data_source.api_management_name
  resource_group_name = each.value.main_rg_name
}

##Create a resource group for the Function App
module "functionapp_rg" {
  source      = "./modules/resource_group"
  for_each    = var.function_apps
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}


##Create a Storage account group for the Function App
module "functionapp_sa" {
  source                            = "./modules/storage_account"
  for_each                          = var.function_apps
  location                          = each.value.location
  storage_account_name              = lower(each.value.storage_account.storage_account_name)
  resource_group_name               = each.value.create_resource_group == true ? module.functionapp_rg[each.key].resource_group_name : each.value.resource_group_name
  private_endpoints_config          = each.value.storage_account.private_endpoints_config == null ? {} : each.value.storage_account.private_endpoints_config
  private_endpoint_subnet_id        = each.value.storage_account.pep_subnet_id
  private_dns_zone_name             = each.value.storage_account.private_dns_zone_name
  virtual_network_private_link_name = each.value.storage_account.virtual_network_private_link_name
  virtual_network_id                = each.value.storage_account.virtual_network_id
  network_rules                     = each.value.storage_account.network_rules
  tags                              = merge(local.tags, var.tags)
}

##Create an Azure Function App
module "functionapp" {
  source                     = "./modules/function_app"
  for_each                   = var.function_apps
  location                   = each.value.location
  resource_group_name        = each.value.create_resource_group == true ? module.functionapp_rg[each.key].resource_group_name : each.value.resource_group_name
  function_app_name_short    = each.value.function_app.function_app_name
  function_app_name          = each.value.function_app.function_app_name
  function_app_version       = each.value.function_app.function_app_version == null ? "~4" : each.value.function_app.function_app_version
  app_service_plan_name      = each.value.function_app.function_app_plan_name
  app_service_plan_kind      = each.value.function_app.function_app_plan_kind == null ? "elastic" : each.value.function_app.function_app_plan_kind
  app_service_plan_tier      = each.value.function_app.function_app_plan_tier == null ? "Dynamic" : each.value.function_app.function_app_plan_tier
  app_service_plan_size      = each.value.function_app.function_app_plan_size == null ? "Y1" : each.value.function_app.function_app_plan_size
  app_service_plan_capacity  = each.value.function_app.function_app_plan_capacity == null ? 1 : each.value.function_app.function_app_plan_capacity
  app_service_environment_id = each.value.function_app.function_app_environment_id == null ? "" : each.value.function_app.function_app_environment_id
  app_settings               = merge(each.value.function_app.function_app_app_settings, local.be_function_app_app_settings)
  #Storage
  storage_account_name       = module.functionapp_sa[each.key].storage_account_name
  storage_account_access_key = module.functionapp_sa[each.key].storage_primary_access_key
  ##Vnet Details
  ip_restriction             = concat(each.value.function_app.ip_restriction, local.ip_restriction)
  create_vnet_swift_conn     = each.value.function_app.create_vnet_integration
  create_private_endpoint    = each.value.function_app.create_private_endpoint
  vnet_integration_subnet_id = each.value.function_app.vnet_integration_subnet_id
  private_endpoint_subnet_id = each.value.function_app.private_endpoint_subnet_id
  private_endpoint_name      = each.value.function_app.private_endpoint_name == null ? "${each.value.function_app.function_app_name}-pe" : each.value.function_app.private_endpoint_name
  #allow_ip_addresses         = each.value.function_app.api_management_public_ip
  tenant_id                  = local.tenant_id
  key_vault_id               = each.value.function_app.key_vault_id
  tags                       = merge(local.tags, var.tags)
  depends_on                 = [module.functionapp_rg, module.functionapp_sa]
}

module "be_sql_vnet_rule" {
  source                             = "./modules/sql_server/sql_server_vnet_rule"
  for_each                           = var.function_apps
  create_virtual_network_rule        = each.value.be_sqlserver_link.create_virtual_network_rule
  sql_virtual_network_rule_name      = each.value.be_sqlserver_link.sql_virtual_network_rule_name
  resource_group_name                = each.value.main_rg_name
  sql_server_name                    = each.value.be_sqlserver_link.sql_server_name
  sql_virtual_network_rule_subnet_id = each.value.be_sqlserver_link.sql_virtual_network_rule_subnet_id
}

module "be_apim_named_value" {
  source                      = "./modules/api_management/named_values"
  for_each                    = var.function_apps
  resource_group_name         = each.value.main_rg_name
  function_rg_name            = each.value.create_resource_group == true ? module.functionapp_rg[each.key].resource_group_name : each.value.resource_group_name
  create_named_value          = each.value.apim.create_named_value == null ? "false" : each.value.apim.create_named_value
  api_management_name         = each.value.apim.api_management_name
  function_app_name           = module.functionapp[each.key].function_app_name #each.value.function_app_name
  key_vault_id                = each.value.apim.key_vault_id
  named_value_name            = each.value.apim.named_value_name
  kv_secret_expiration_date   = each.value.be_keyvault.secret_expiration_date
  principal_display_name      = var.principal_display_name
  resource_id                 = module.functionapp[each.key].function_app_id
  tenant_id                   = local.tenant_id
  apim_certificate_thumbprint = each.value.apim.apim_certificate_thumbprint == null ? module.apim_certificate[each.key].apim_certificate_thumbprint : each.value.apim.apim_certificate_thumbprint
  backend_name                = each.value.apim.backend_name

  depends_on = [module.functionapp]
}

module "backend_function_app_diagnostic" {
  source                = "./modules/diagnostic_setting"
  for_each              = var.function_apps
  name                  = each.value.diagnostic_setting.diagnostic_name
  resource_id           = module.functionapp[each.key].function_app_id
  logs_destinations_ids = each.value.diagnostic_setting.log_analytics_workspace_id
  retention_days        = each.value.diagnostic_setting.retention_days
}

module "apim_kv_certificate" {
  source                  = "./modules/key_vault/key_vault_certificate"
  for_each                = var.function_apps
  create_apim_certificate = each.value.apim.create_apim_certificate == null ? "false" : each.value.apim.create_apim_certificate
  key_vault_id            = each.value.apim.key_vault_id
  apim_certificate_name   = each.value.apim.apim_certificate_name
  cert_subject            = each.value.apim.cert_subject
  cert_validity           = each.value.apim.cert_validity
  key_usage               = each.value.apim.key_usage
  cert_issuer_name        = each.value.apim.cert_issuer_name
  cert_key_export         = each.value.apim.cert_key_export
  cert_key_type           = each.value.apim.cert_key_type
  cert_reuse_key          = each.value.apim.cert_reuse_key
  cert_key_size           = each.value.apim.cert_key_size
  cert_content_type       = each.value.apim.cert_content_type
}

module "apim_certificate" {
  source                  = "./modules/api_management/certificates"
  for_each                = var.function_apps
  create_apim_certificate = each.value.apim.create_apim_certificate
  apim_certificate_name   = each.value.apim.apim_certificate_name
  api_management_name     = each.value.apim.api_management_name
  resource_group_name     = each.value.main_rg_name
  key_vault_id            = each.value.apim.key_vault_id
  api_management_id       = each.value.apim.api_management_id
  depends_on              = [module.apim_kv_certificate]
}

