output "resource_group_name" {
  value       = try(azurerm_resource_group.main_rg[0].name, null)
  description = "Resource group name"
}

output "resource_group_id" {
  value       = try(azurerm_resource_group.main_rg[0].id, null)
  description = "Resource group generated id"
}

output "resource_group_location" {
  value       = try(azurerm_resource_group.main_rg[0].location, null)
  description = "Resource group location (region)"
}

