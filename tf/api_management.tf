##Create a resource group for the app service
##Type object app_services
module "api_management_rg" {
  source      = "./modules/resource_group"
  for_each    = var.api_managements
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}
##Create an Api Management
module "api_management_apim" {
  source                        = "./modules/api_management"
  for_each                      = var.api_managements
  resource_group_name           = each.value.create_resource_group == true ? module.api_management_rg[each.key].resource_group_name : each.value.resource_group_name
  location                      = each.value.location
  api_management_name           = "${each.value.api_management_name}-${random_string.unique.result}"
  virtual_network_type          = each.value.virtual_network_type
  sku_name                      = each.value.sku_name
  virtual_network_configuration = each.value.virtual_network_configuration
  min_api_version               = each.value.min_api_version
  display_name                  = each.value.display_name
  tags                          = merge(local.tags, var.tags)
  depends_on                    = [module.api_management_rg]
}