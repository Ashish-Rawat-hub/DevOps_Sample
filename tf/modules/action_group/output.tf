output "action_group_id" {
  value = try(azurerm_monitor_action_group.action_group[0].id, null)
}