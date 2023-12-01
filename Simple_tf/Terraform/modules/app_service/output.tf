output "webapp_identity" {
  value = azurerm_windows_web_app.webapp.identity
}

output "webapp_name" {
  value = azurerm_windows_web_app.webapp.name
}

output "webapp_id" {
  value = azurerm_windows_web_app.webapp.id
}

output "webapp_url" {
  value = azurerm_windows_web_app.webapp.default_hostname
}