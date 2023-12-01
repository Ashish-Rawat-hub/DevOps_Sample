# output "app_service_id" {
#   description = "The id of the app service"
#   value       = azurerm_windows_web_app.main[each.key].id
# }

# output "app_service_id" {
#   value = {
#     for k, v in azurerm_windows_web_app.main : k => v.id
#   }
# }

# output "app_service_default_hostname" {
#   value = {
#     for k, v in azurerm_windows_web_app.main : k => v.default_hostname
#   }
# }


output "app_service_id" {
  description = "Default Hostname of the app service"
  value       = azurerm_windows_web_app.main.id
}

output "default_hostname" {
  description = "Default Hostname of the app service"
  value       = azurerm_windows_web_app.main.default_hostname
}

output "app_service_identity" {
  description = "System Assigned Identity of App service"
  value       = azurerm_windows_web_app.main.identity 
}