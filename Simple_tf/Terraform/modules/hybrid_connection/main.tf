resource "azurerm_relay_namespace" "example" {
  name                = var.relay_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.relay_sku
  tags                = var.tags
}

resource "azurerm_relay_hybrid_connection" "example" {
  name                 = var.hybrid_connection_name
  resource_group_name  = var.resource_group_name
  relay_namespace_name = azurerm_relay_namespace.example.name
  user_metadata        = jsonencode(
            [
                {
                    key   = "endpoint"
                    value = "${var.hybrid_connection_hostname}:${var.hybrid_connection_port}"
                }
            ]
        )
}

resource "azurerm_web_app_hybrid_connection" "relay" {
  web_app_id = var.webapp_id
  relay_id   = azurerm_relay_hybrid_connection.example.id
  hostname   = var.hybrid_connection_hostname
  port       = var.hybrid_connection_port
}