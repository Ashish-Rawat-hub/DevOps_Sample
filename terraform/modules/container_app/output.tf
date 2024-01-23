output "container_app_id" {
  value = azurerm_container_app.container_app.id
}

output "container_app_identity" {
  value = azurerm_container_app.container_app.identity.0.principal_id
}