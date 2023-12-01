output "resource_group_name" {
  description = "Resource group name"
  value = try(azurerm_resource_group.rg[0].name, null)
}

output "resource_group_location" {
  description = "Resource group location"
  value = try(azurerm_resource_group.rg[0].location, null)
}