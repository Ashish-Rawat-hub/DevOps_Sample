##Create a resource group for the azure virtual network
module "vnet_rg" {
  source      = "./modules/resource_group"
  for_each    = var.networks
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}

##Create a azure virtual network
module "azure_virtual_network" {
  source              = "./modules/virtual_network"
  for_each            = var.networks
  create              = each.value.create_vnet
  environment         = var.environment
  vnet_location       = each.value.location
  resource_group_name = each.value.create_resource_group == true ? module.vnet_rg[each.key].resource_group_name : each.value.resource_group_name
  vnet_name           = each.value.vnet.vnet_name
  address_space       = each.value.vnet.address_space
  subnets             = each.value.vnet.subnets
  nsg_name            = each.value.vnet.nsg_name
  nsg_rules           = each.value.vnet.nsg_rules == null ? {} : each.value.vnet.nsg_rules
  tags                = merge(local.tags, var.tags)
  depends_on          = [module.vnet_rg]
}
