#data "azurerm_client_config" "current" {}

resource "azurerm_app_configuration" "appconf" {
  name                = var.app_configuration_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = var.sp_object_id #data.azurerm_client_config.current.object_id
}


resource "azurerm_app_configuration_key" "app_config_key" {
  count                  = length(var.app_config_key)
  configuration_store_id = azurerm_app_configuration.appconf.id
  key                    = var.app_config_key[count.index].key
  type                   = var.app_config_key[count.index].type
  label                  = var.app_config_key[count.index].label
  value                  = var.app_config_key[count.index].value
  vault_key_reference    = var.app_config_key[count.index].vault_key_reference

  depends_on = [
    azurerm_role_assignment.appconf_dataowner
  ]
}