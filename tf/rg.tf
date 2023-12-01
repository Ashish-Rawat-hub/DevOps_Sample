##Create a resource group
module "rg" {
  source      = "./modules/resource_group"
  for_each    = var.resource_groups
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}