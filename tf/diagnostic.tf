/* ##Create a Storage account for the audit logs
module "shared_infra_audit_sa" {
  source               = "./modules/storage_account"
  for_each             = var.diagnostic
  location             = each.value.location
  storage_account_name = lower("${each.value.auditing_storage_account_name}${random_string.unique.result}")
  resource_group_name  = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name
  private_endpoints_config          = each.value.private_endpoints_config == null ? {} : each.value.private_endpoints_config
  subnet_id                         = each.value.subnet_id
  private_dns_zone_name             = each.value.private_dns_zone_name
  virtual_network_private_link_name = each.value.virtual_network_private_link_name
  virtual_network_id                = each.value.virtual_network_id  
  tags                 = merge(local.tags, var.tags)
} */

/*
##Create App Insights 
module "audit_app_insights" {
  source                    = "./modules/app_insights"
  for_each                  = var.diagnostic
  location                  = each.value.location
  resource_group_name       = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name
  log_analytics_workspace   = each.value.log_analytics_workspace
  application_insights_name = each.value.application_insights_name
  tags                      = merge(local.tags, var.tags)
}

module "sqlserver_diagnostic_master" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.sqlserver_diagnostic_name_master
  resource_id                = module.shared_infra_sql[each.key].mssql_server_id == "" ? "" : "${module.shared_infra_sql[each.key].mssql_server_id}/databases/master"
  #log_categories             = each.value.log_categories
  logs_destinations_ids      = "${[module.audit_app_insights[each.key].log_analytics_workspace_id, module.shared_infra_audit_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days

  depends_on = [module.shared_infra_sql]
}

module "sqlserver_diagnostic_db" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.sqlserver_diagnostic_name_db
  resource_id                = module.shared_infra_sql[each.key].mssql_server_id == "" ? "" : "${module.shared_infra_sql[each.key].mssql_server_id}/databases/${each.value.mssql_db_name}"
  #log_categories             = each.value.log_categories
  logs_destinations_ids      = "${[module.audit_app_insights[each.key].log_analytics_workspace_id, module.shared_infra_audit_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days

  depends_on = [module.shared_infra_sql]
}

module "keyvault_diagnostic" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.kv_diagnostic_name
  resource_id                = module.fdb_infra_keyvault[each.key].key_vault_id
  #log_categories             = each.value.log_categories
  logs_destinations_ids      = "${[module.audit_app_insights[each.key].log_analytics_workspace_id, module.shared_infra_audit_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days
}

module "app_service_diagnostic" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.app_service_diagnostic_name
  resource_id                = module.fdb_infra_appservice[each.key].app_service_id
  #log_categories             = each.value.log_categories
  logs_destinations_ids      = "${[module.audit_app_insights[each.key].log_analytics_workspace_id, module.shared_infra_audit_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days
}

module "availability_test_logic_app" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.availability_test_logic_app_diagnostic_name
  resource_id                = module.logic_app_availability[each.key].logic_app_id
  #log_categories             = each.value.log_categories
  logs_destinations_ids      = "${[module.logic_app_insights[each.key].log_analytics_workspace_id, module.logic_app_functionapp_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days
}

module "availability_alert_logic_app" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.availability_alert_logic_app_diagnostic_name
  resource_id                = module.logic_app_alert[each.key].logic_app_id
  #log_categories             = each.value.log_categories
  logs_destinations_ids      = "${[module.logic_app_insights[each.key].log_analytics_workspace_id, module.logic_app_functionapp_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days
}

module "api_management_audit" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.api_management_audit_name
  resource_id                = module.fdb_infra_apim[each.key].api_management_id
  logs_destinations_ids      = "${[module.audit_app_insights[each.key].log_analytics_workspace_id, module.shared_infra_audit_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days
}

module "vnet_primary_audit" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.primary_vnet_audit_name
  resource_id                = module.shared_infra_vnet[each.key].vnet_id
  logs_destinations_ids      = "${[module.audit_app_insights[each.key].log_analytics_workspace_id, module.shared_infra_audit_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days
}

module "vnet_availability_audit" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.diagnostic
  name                       = each.value.availability_vnet_audit_name
  resource_id                = module.availability_vnet[each.key].vnet_id
  logs_destinations_ids      = "${[module.logic_app_insights[each.key].log_analytics_workspace_id, module.logic_app_functionapp_sa[each.key].storage_account_id]}"
  retention_days             = each.value.retention_days
} */