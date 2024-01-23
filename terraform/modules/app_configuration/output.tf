output "app_configuration_identity" {
  value = azurerm_app_configuration.appconf.identity
}

output "app_config_conn_string" {
  value = azurerm_app_configuration.appconf.primary_read_key[0].connection_string
}