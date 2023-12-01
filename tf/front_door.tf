##Create a resource group for the Function App
module "front_door_rg" {
  source      = "./modules/resource_group"
  for_each    = var.front_doors
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}

#Create Azure Front Door
module "front_door" {
  source                         = "./modules/front_door"
  for_each                       = var.front_doors
  front_door_name                = each.value.front_door_name
  resource_group_name            = each.value.create_resource_group == true ? module.front_door_rg[each.key].resource_group_name : each.value.resource_group_name
  front_door_sku_name            = each.value.front_door_sku_name
  front_door_load_balancing      = each.value.frontdoor_loadbalancer
  frontend_backend_host          = each.value.front_door_hostname
  front_door_health_probe        = each.value.frontdoor_health_probe
  frontdoor_firewall_policy_name = each.value.frontdoor_firewall_policy_name
  frontdoor_security_policy_name = each.value.frontdoor_security_policy_name
  tags                           = merge(local.tags, var.tags)
  depends_on                     = [module.shared_infra_rg]
}