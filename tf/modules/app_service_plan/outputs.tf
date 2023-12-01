output "app_service_plan_id" {
  description = "The id of the app service plan"
  value       = azurerm_service_plan.main.id
}