# output "functionapp_id" {
#   value = {
#     for k, v in azurerm_function_app.functionapp : k => v.id
#   }
# }

output "function_app_id" {
  description = "ID of the Function App"
  value       = azurerm_function_app.functionapp.id
}

output "function_app_hostname" {
  description = "Default Hostname of the function app"
  value       = azurerm_function_app.functionapp.default_hostname 
}

output "function_app_identity" {
  description = "System Assigned Identity of Function App"
  value = azurerm_function_app.functionapp.identity
}

output "function_app_name" {
  description = "Name of the function app"
  value = azurerm_function_app.functionapp.name
}