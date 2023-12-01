output "deployment_token" {
  value = azurerm_static_site.ui.api_key
}

output "ui_webapp_url" {
  value = azurerm_static_site.ui.default_host_name
}