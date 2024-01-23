resource "random_string" "random" {
  length           = 2
  special          = false
  upper            = false  
}

##Create a resource group for the app service
##Type object app_services
module "resource_group" {
  source      = "./modules/resource_group"
  for_each    = var.infra
  create      = each.value.create_resource_group
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = var.tags
}

module "container_app_env" {
  source                      = "./modules/container_app_environment"
  for_each                    = var.infra
  container_app_env_name      = each.value.container_app_env_name
  location                    = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.location
  resource_group_name         = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  log_analytics_workspace_id  = module.app_insights[each.key].log_analytics_workspace_id
}

module "container_app_ui" {
  source                       = "./modules/container_app"
  for_each                     = var.infra
  container_app_name           = each.value.container_app_name_ui
  container_app_env_id         = module.container_app_env[each.key].container_app_env_id
  resource_group_name          = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  ingress                      = each.value.container_app_ingress_ui
  container_name               = each.value.container_name_ui
  container_cpu                = each.value.container_cpu_ui
  container_memory             = each.value.container_memory_ui
  container_env                = each.value.container_env_ui
  container_app_registry       = each.value.container_app_registry_ui == null ? local.registry_details : each.value.container_app_registry_ui
}

module "container_app_api" {
  source                       = "./modules/container_app"
  for_each                     = var.infra
  container_app_name           = each.value.container_app_name_api
  container_app_env_id         = module.container_app_env[each.key].container_app_env_id
  resource_group_name          = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  container_name               = each.value.container_name_api
  container_cpu                = each.value.container_cpu_api
  container_memory             = each.value.container_memory_api
  container_env                = each.value.container_env_api
  container_app_registry       = each.value.container_app_registry_api == null ? local.registry_details : each.value.container_app_registry_api
}

module "app_insights" {
  source                       = "./modules/app_insights"
  for_each                     = var.infra
  application_insights_name    = each.value.application_insights_name
  log_analytics_workspace      = each.value.log_analytics_workspace
  sku                          = each.value.sku
  location                     = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.location
  resource_group_name          = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
}

module "app_configuration" {
  source                 = "./modules/app_configuration"
  for_each               = var.infra
  app_configuration_name = each.value.app_configuration_name
  resource_group_name    = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  location               = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  app_config_key         = each.value.app_config_key
  sp_object_id           = local.sp_object_id
  tags                   = var.tags
}

module "storage_account" {
  source                       = "./modules/storage_account"
  for_each                     = var.infra
  storage_account_name         = "${each.value.storage_account_name}${random_string.random.result}"
  resource_group_name          = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  location                     = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  account_tier                 = each.value.account_tier
  account_replication_type     = each.value.account_replication_type
}

module "key_vault" {
  source                             = "./modules/keyvault"
  for_each                           = var.infra
  keyvault_name                      = "${each.value.keyvault_name}-${random_string.random.result}"
  resource_group_name                = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  location                           = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  tenant_id                          = local.tenant_id
  keyvault_sku                       = each.value.keyvault_sku
  tags                               = var.tags
}

module "container_registry" {
  source                             = "./modules/container_registry"
  for_each                           = var.infra
  container_registry_name            = each.value.container_registry_name
  resource_group_name                = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  resource_group_location            = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  container_registry_sku             = each.value.container_registry_sku
  admin_enabled                      = each.value.admin_enabled
}

module "rbac_acr_api" {
  source = "./modules/RBAC"
  for_each = var.infra
  principal_id                       = module.container_app_api[each.key].container_app_identity
  role_definition_name               = "AcrPull"
  rbac_scope                         = module.container_registry[each.key].container_registry_id
}

module "rbac_acr_ui" {
  source = "./modules/RBAC"
  for_each = var.infra
  principal_id                       = module.container_app_ui[each.key].container_app_identity
  role_definition_name               = "AcrPull"
  rbac_scope                         = module.container_registry[each.key].container_registry_id
}

module "rbac_acr_svc_conn" {
  source = "./modules/RBAC"
  for_each = var.infra
  principal_id                       = var.service_principal_id
  role_definition_name               = "AcrPull"
  rbac_scope                         = module.container_registry[each.key].container_registry_id
}