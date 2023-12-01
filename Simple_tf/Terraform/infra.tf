resource "random_string" "unique" {
  length  = 3
  numeric = true
  special = false
}

module "resource_group" {
  source                  = "./modules/resource_group"
  for_each                = var.infra
  create                  = each.value.create_resource_group
  resource_group_name     = each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  tags                    = local.tags
}

module "service_plan" {
  source                  = "./modules/app_service_plan"
  for_each                = var.infra
  asp_name                = each.value.asp_name
  resource_group_name     = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  resource_group_location = each.value.resource_group_location
  service_plan_sku        = each.value.service_plan_sku
  os_type                 = each.value.os_type
  tags                    = local.tags
  depends_on = [module.resource_group]
}

module "app_service_api" {
  source                          = "./modules/app_service"
  for_each                        = var.infra
  resource_group_name             = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  resource_group_location         = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  webapp_name                     = each.value.webapp_name_api
  current_stack                   = each.value.current_stack_api
  dotnet_version                  = each.value.dotnet_version_api
  service_plan_id                 = module.service_plan[each.key].service_plan_id
  app_settings                    = local.api_app_service_settings
  app_service_connection_string   = local.api_app_service_conn_string
  tags                            = local.tags
  ui_webapp_url                   = each.value.webapp_cors_api
  create_vnet_swift_conn          = each.value.create_vnet_swift_conn
  app_service_vnet_integration_subnet_id = data.azurerm_subnet.subnet["{{env}}"].id
  depends_on                      = [module.app_insights_api, module.service_plan, module.resource_group]
}

module "app_service_ui" {
  source                          = "./modules/app_service"
  for_each                        = var.infra
  resource_group_name             = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  resource_group_location         = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  webapp_name                     = each.value.webapp_name_ui
  current_stack                   = each.value.current_stack_ui
  dotnet_version                  = each.value.dotnet_version_ui
  service_plan_id                 = module.service_plan[each.key].service_plan_id
  app_settings                    = local.ui_app_service_settings
  ip_restriction                  = each.value.ip_restriction
  tags                            = local.tags
  depends_on                      = [module.app_insights_ui, module.service_plan]
}

# module "static_web_app" {
#   source                          = "./modules/static_web_app"
#   for_each                        = var.infra
#   static_app_name                 = each.value.static_app_name
#   resource_group_name             = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
#   location                        = each.value.static_app_location
#   static_sku_tier                 = each.value.static_sku_tier
#   static_sku_size                 = each.value.static_sku_size
#   app_insights_intrumentation_key = module.app_insights_ui[each.key].instrumentation_key
#   ApiBasePath                     = each.value.ApiBasePath
#   tags                            = local.tags
#   depends_on                      = [module.app_insights_ui, module.resource_group]
# }

module "log_analytics" {
  source                      = "./modules/log_analytics_workspace"
  for_each                    = var.infra
  resource_group_name         = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  location                    = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  app_insights_workspace_name = each.value.app_insights_workspace_name
  log_analytics_workspace_sku = each.value.log_analytics_workspace_sku
  retention_in_days           = each.value.retention_in_days
  tags                        = local.tags
  depends_on                  = [module.resource_group]
}

module "app_insights_ui" {
  source              = "./modules/app_insights"
  for_each            = var.infra
  app_insights_name   = each.value.app_insights_name_ui
  resource_group_name = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  location            = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  app_type            = each.value.app_type_ui
  tags                = local.tags
  depends_on          = [module.resource_group]
}

module "app_insights_api" {
  source              = "./modules/app_insights"
  for_each            = var.infra
  app_insights_name   = each.value.app_insights_name_api
  resource_group_name = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  location            = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  app_type            = each.value.app_type_api
  tags                = local.tags
  depends_on          = [module.resource_group]
}

module "keyvault" {
  source              = "./modules/keyvault"
  for_each            = var.infra
  keyvault_name       = "${each.value.keyvault_name}-${random_string.unique.result}"
  resource_group_name = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  location            = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  keyvault_sku        = each.value.keyvault_sku
  tenant_id           = local.tenant_id  
  kv_secrets             = {
    "DefaultConnection"               = each.value.DefaultConnection
  }
  tags                = local.tags
}

module "keyvault_access_policies" {
  source                     = "./modules/keyvault/access_policy"
  for_each                   = var.infra
  key_vault_id               = module.keyvault[each.key].key_vault_id
  reader_objects_ids         = concat(local.api_app_service_identity, local.app_configuration_identity)
  admin_objects_ids          = ["${local.sp_object_id}"]  
  tenant_id                  = local.tenant_id
}

module "app_configuration" {
  source                 = "./modules/app_configuration"
  for_each               = var.infra
  app_configuration_name = each.value.app_configuration_name
  resource_group_name    = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_name : each.value.resource_group_name
  location               = each.value.create_resource_group == true ? module.resource_group[each.key].resource_group_location : each.value.resource_group_location
  app_config_key         = concat(each.value.app_config_key, local.app_configuration)
  sp_object_id           = local.sp_object_id
  tags                   = local.tags  
}
