
resource "azurerm_api_management" "apim" {
  name                = var.api_management_name
  location            = var.location
  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email
  sku_name        = var.sku_name
  min_api_version = var.min_api_version
  tags            = var.tags 

  virtual_network_type = var.virtual_network_type

  dynamic "virtual_network_configuration" {
    for_each = toset(var.virtual_network_configuration)
    content {
      subnet_id = virtual_network_configuration.value
    }
  }

  hostname_configuration {
    proxy {
      host_name = "${var.api_management_name}.azure-api.net"
      negotiate_client_certificate = true
    }
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_subscription" "apim_subscription" {
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  api_id              = var.api_id
  user_id             = var.user_id
  product_id          = var.product_id
  display_name        = var.display_name
  allow_tracing       = var.allow_tracing
  state               = var.state

  lifecycle {
    ignore_changes = [ api_id ]
  }
}