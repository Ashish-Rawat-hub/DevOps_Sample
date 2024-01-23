output "container_registry_id" {
  value = azurerm_container_registry.acr.id
}

output "server_hostname" {
  value = azurerm_container_registry.acr.login_server
}