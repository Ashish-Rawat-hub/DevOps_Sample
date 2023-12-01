locals {
    fe_app_service_settings = try({
      "APPINSIGHTS_CONNECTIONSTRING"                        = local.webapp_app_insight_conn_string
      "APPINSIGHTS_INSTRUMENTATIONKEY"                      = local.webapp_app_insight_instrumentation_key
    }, {})

    webapp_app_insight_conn_string = try(data.azurerm_application_insights.fe_app_insights["{{env}}"].connection_string, "")
    webapp_app_insight_instrumentation_key = try(data.azurerm_application_insights.fe_app_insights["{{env}}"].instrumentation_key, "") 
}

##Data Source
data "azurerm_application_insights" "fe_app_insights" {
  for_each            = var.app_services
  name                = each.value.data_source.app_insight_name
  resource_group_name = each.value.data_source.main_rg_name
}

##Create a resource group for the app service
##Type object app_services
module "app_service_rg" {
  source      = "./modules/resource_group"
  for_each    = var.app_services
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}

##Create an app service plan for the app service
##Type object app_services
module "app_service_plan" {
  source              = "./modules/app_service_plan"
  for_each            = var.app_services
  resource_group_name = each.value.create_resource_group == true ? module.app_service_rg[each.key].resource_group_name : each.value.resource_group_name
  location            = each.value.location
  asp_name            = "${each.value.app_service.app_service_plan_name}-${random_string.unique.result}"
  os_type             = each.value.app_service.app_service_plan_os_type
  sku_name            = each.value.app_service.app_service_plan_sku
  tags                = merge(local.tags, var.tags)
  depends_on          = [module.app_service_rg]
}

##Create an app service 
##Type object app_services
module "app_service" {
  source                                  = "./modules/app_service"
  for_each                                = var.app_services
  resource_group_name                     = each.value.create_resource_group == true ? module.app_service_rg[each.key].resource_group_name : each.value.resource_group_name
  location                                = each.value.location
  app_service_name                        = each.value.app_service.app_service_name
  app_service_plan_id                     = module.app_service_plan[each.key].app_service_plan_id
  https_only                              = each.value.app_service.https_only == null ? false : each.value.app_service.https_only
  identity                                = each.value.app_service.identity
  dotnet_version                          = each.value.app_service.dotnet_version
  app_settings                            = merge(each.value.app_service.app_settings, local.fe_app_service_settings)
  site_config                             = each.value.app_service.site_config
  ip_restriction                          = each.value.app_service.ip_restriction
  app_service_vnet_integration_subnet_id  = each.value.app_service.vnet_integration_subnet_id
  create_vnet_swift_conn                  = each.value.app_service.create_vnet_swift_conn == null ? true : each.value.app_service.create_vnet_swift_conn
  create_private_endpoint                 = each.value.app_service.create_private_endpoint == null ? false : each.value.app_service.create_private_endpoint
  private_endpoint_subnet_id              = each.value.app_service.pep_subnet_id
  private_endpoint_manual_connection      = each.value.app_service.pep_manual_connection == null ? false : each.value.app_service.pep_manual_connection
  private_endpoint_subresource_names      = each.value.app_service.pep_subresource_names == null ? ["sites"] : each.value.app_service.pep_subresource_names
  private_endpoint_private_dns_zone_group = each.value.app_service.pep_pvt_dnsg == null ? {} : each.value.app_service.pep_pvt_dnsg
  key_vault_id                            = each.value.app_service.key_vault_id == null ? module.key_vault[each.key].key_vault_id : each.value.app_service.key_vault_id
  tenant_id                               = local.tenant_id
  tags                                    = merge(local.tags, var.tags)
  depends_on                              = [module.app_service_rg, module.app_service_plan]
}

module "fe_as_diag" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.app_services
  name                       = each.value.diagnostic.fe_as_diag_name
  resource_id                = module.app_service[each.key].app_service_id
  logs_destinations_ids      = each.value.diagnostic.audit_log_analytics_id
  retention_days             = each.value.diagnostic.diag_retention_days
}