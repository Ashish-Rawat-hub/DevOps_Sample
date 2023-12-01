/* ##Create a resource group for the azure logic app
module "logic_app_rg" {
  source      = "./modules/resource_group"
  for_each    = var.logic_app
  create      = each.value.logic_app_create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.logic_app_location
  rg_name     = each.value.logic_app_resource_group_name
  tags        = merge(local.tags, var.tags)
}

##Create a Network for the Availability Function App
module "availability_vnet" {
  source              = "./modules/virtual_network"
  for_each            = var.logic_app
  create              = each.value.create_vnet
  environment         = var.environment
  vnet_location       = each.value.logic_app_location
  resource_group_name = each.value.logic_app_create_resource_group == true ? module.logic_app_rg[each.key].resource_group_name : each.value.logic_app_resource_group_name
  vnet_name           = each.value.vnet.vnet_name
  address_space       = each.value.vnet.address_space
  subnets             = each.value.vnet.subnets
  nsg_name            = each.value.vnet.nsg_name
  nsg_rules           = each.value.vnet.nsg_rules == null ? {} : each.value.vnet.nsg_rules
  tags                = merge(local.tags, var.tags)
  depends_on          = [module.logic_app_rg]
}

##App insight for availability function
module "logic_app_insights" {
  source                    = "./modules/app_insights"
  for_each                  = var.logic_app
  location                  = each.value.logic_app_location
  resource_group_name       = each.value.logic_app_create_resource_group == true ? module.logic_app_rg[each.key].resource_group_name : each.value.logic_app_resource_group_name
  log_analytics_workspace   = each.value.logic_app_log_analytics_workspace
  application_insights_name = each.value.logic_app_application_insights_name
  tags                      = merge(local.tags, var.tags)
}

##Create a Storage account group for the Function App
module "logic_app_functionapp_sa" {
  source               = "./modules/storage_account"
  for_each             = var.logic_app
  location             = each.value.logic_app_location
  storage_account_name = lower(each.value.logic_app_storage_account_name)
  resource_group_name  = each.value.logic_app_create_resource_group == true ? module.logic_app_rg[each.key].resource_group_name : each.value.logic_app_resource_group_name
  virtual_network_subnet_ids = module.availability_vnet[each.key].vnet_subnets["{{prefix}}-{{env}}-availability-functionapp-subnet-{{secondary_postfix}}"].id
  private_endpoints_config          = each.value.private_endpoints_config == null ? {} : each.value.private_endpoints_config
  subnet_id                         = try(module.availability_vnet[each.key].vnet_subnets["{{prefix}}-{{env}}-availability-sa-subnet-{{secondary_postfix}}"].id, each.value.subnet_id)
  private_dns_zone_name             = each.value.private_dns_zone_name
  virtual_network_private_link_name = each.value.virtual_network_private_link_name
  virtual_network_id                = each.value.virtual_network_id   
  tags                 = merge(local.tags, var.tags)
  depends_on = [module.logic_app_rg, module.availability_vnet]
}

##Create an Azure Function App
module "logic_app_functionapp" {
  source                           = "./modules/function_app"
  for_each                         = var.logic_app
  location                         = each.value.logic_app_location
  resource_group_name              = each.value.logic_app_create_resource_group == true ? module.logic_app_rg[each.key].resource_group_name : each.value.logic_app_resource_group_name
  function_app_name                = each.value.logic_app_function_app_name
  function_app_version             = each.value.logic_app_function_app_version == null ? "~4" : each.value.logic_app_function_app_version
  app_service_plan_name            = each.value.logic_app_function_app_plan_name
  app_service_plan_kind            = each.value.logic_app_function_app_plan_kind == null ? "elastic" : each.value.logic_app_app_service_plan_kind
  app_service_plan_tier            = each.value.logic_app_function_app_plan_tier == null ? "Dynamic" : each.value.logic_app_function_app_plan_tier
  app_service_plan_size            = each.value.logic_app_function_app_plan_size == null ? "Y1" : each.value.logic_app_function_app_plan_size
  app_service_plan_capacity        = each.value.logic_app_function_app_plan_capacity == null ? 1 : each.value.logic_app_function_app_plan_capacity
  app_service_environment_id       = each.value.logic_app_function_app_environment_id
  create_vnet_swift_conn           = each.value.logic_app_function_app_create_vnet_swift_conn == null ? true : each.value.logic_app_function_app_create_vnet_swift_conn
  storage_account_name             = module.logic_app_functionapp_sa[each.key].storage_account_name
  storage_account_tier             = each.value.logic_app_storage_account_tier
  app_settings                     = merge(each.value.logic_app_function_app_app_settings == null ? {} : each.value.logic_app_function_app_app_settings, local.availability_function_settings)
  storage_account_access_key       = module.logic_app_functionapp_sa[each.key].storage_primary_access_key
  storage_account_replication_type = each.value.logic_app_storage_account_replication_type
  create_private_endpoint          = each.value.logic_app_storage_create_private_endpoint == null ? false : each.value.logic_app_storage_create_private_endpoint
  vnet_integration_subnet_id       = module.availability_vnet[each.key].vnet_subnets["{{prefix}}-{{env}}-availability-functionapp-subnet-{{secondary_postfix}}"].id
  private_endpoint_subnet_id       = each.value.logic_app_function_app_private_endpoint_subnet_id
  allow_ip_addresses               = each.value.logic_app_function_app_apim_public_ip_addresses
  instrumentation_key              = module.logic_app_insights[each.key].instrumentation_key
  key_vault_name                   = module.fdb_infra_keyvault[each.key].key_vault_name
  key_vault_resource_group_name    = each.value.availability_keyvault_resource_group_name
  ftps_state                       = each.value.logic_app_function_app_ftps_state == null ? "FtpsOnly" : each.value.logic_app_function_app_ftps_state
  tags                             = merge(local.tags, var.tags)
  depends_on                       = [module.logic_app_rg, module.availability_vnet, module.logic_app_functionapp_sa, module.logic_app_insights, module.fdb_infra_keyvault]
}


module "keyvault_availability_func" {
  source            = "./modules/function_app/function"
  for_each          = var.logic_app
  function_app_id   = module.logic_app_functionapp[each.key].function_app_id
  function_name     = each.value.kv_availability_function_name
  function_language = each.value.availability_function_language
  depends_on = [
    module.logic_app_functionapp
  ]
}

module "sql_server_availability_func" {
  source            = "./modules/function_app/function"
  for_each          = var.logic_app
  function_app_id   = module.logic_app_functionapp[each.key].function_app_id
  function_name     = each.value.sql_server_availability_function_name
  function_language = each.value.availability_function_language
  depends_on = [
    module.logic_app_functionapp
  ]
}


module "keyvault_availability_alert_func" {
  source            = "./modules/function_app/function"
  for_each          = var.logic_app
  function_app_id   = module.logic_app_functionapp[each.key].function_app_id
  function_name     = each.value.kv_availability_alert_function_name
  function_language = each.value.availability_function_language
  depends_on = [
    module.logic_app_functionapp
  ]
}

module "sql_server_availability_alert_func" {
  source            = "./modules/function_app/function"
  for_each          = var.logic_app
  function_app_id   = module.logic_app_functionapp[each.key].function_app_id
  function_name     = each.value.sql_server_availability_alert_function_name
  function_language = each.value.availability_function_language
  depends_on = [
    module.logic_app_functionapp
  ]
}


module "logic_app_availability" {
  source                           = "./modules/logic_app"
  for_each                         = var.logic_app  
  function_id                      = module.logic_app_functionapp[each.key].function_app_id
  template_deployment_name         = each.value.availability_template_deployment_name
  resource_group_name              = each.value.logic_app_create_resource_group == true ? module.logic_app_rg[each.key].resource_group_name : each.value.logic_app_resource_group_name
  workflow_name                    = each.value.availability_workflow_name
  location                         = each.value.logic_app_location
  keyvault_function_name           = each.value.kv_availability_function_name
  sqlserver_function_name          = each.value.sql_server_availability_function_name
  env                              = each.value.env
  frequency                        = each.value.frequency
  interval                         = each.value.interval
  deployment_mode                  = each.value.deployment_mode
  keyvault_delay_frequency         = each.value.keyvault_delay_frequency
  sqlserver_delay_frequency        = each.value.sqlserver_delay_frequency
  keyvault_delay_unit              = each.value.keyvault_delay_unit
  sqlserver_delay_unit             = each.value.sqlserver_delay_unit
  depends_on = [
    module.logic_app_functionapp, module.keyvault_availability_func, module.sql_server_availability_func
  ]
}

module "logic_app_alert" {
  source                           = "./modules/logic_app"
  for_each                         = var.logic_app  
  function_id                      = module.logic_app_functionapp[each.key].function_app_id
  template_deployment_name         = each.value.alert_template_deployment_name
  resource_group_name              = each.value.logic_app_create_resource_group == true ? module.logic_app_rg[each.key].resource_group_name : each.value.logic_app_resource_group_name
  workflow_name                    = each.value.alert_workflow_name
  location                         = each.value.logic_app_location
  keyvault_function_name           = each.value.kv_availability_alert_function_name
  sqlserver_function_name          = each.value.sql_server_availability_alert_function_name
  env                              = each.value.env
  frequency                        = each.value.frequency
  interval                         = each.value.interval
  deployment_mode                  = each.value.deployment_mode
  keyvault_delay_frequency         = each.value.keyvault_delay_frequency
  sqlserver_delay_frequency        = each.value.sqlserver_delay_frequency
  keyvault_delay_unit              = each.value.keyvault_delay_unit
  sqlserver_delay_unit             = each.value.sqlserver_delay_unit
  depends_on = [
    module.logic_app_functionapp, module.keyvault_availability_alert_func, module.sql_server_availability_alert_func
  ]
} */