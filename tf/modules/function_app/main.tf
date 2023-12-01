resource "azurerm_app_service_plan" "functionapp_service_plan" {
  name                       = var.app_service_plan_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  kind                       = var.app_service_plan_kind
  app_service_environment_id = var.app_service_environment_id
  tags                       = var.tags

  sku {
    tier     = var.app_service_plan_tier
    size     = var.app_service_plan_size
    capacity = var.app_service_plan_capacity
  }
  lifecycle {
    ignore_changes = [sku]
  }
}

resource "azurerm_function_app" "functionapp" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.functionapp_service_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  version                    = var.function_app_version
  https_only                 = var.https_only 
  tags                       = var.tags
  identity {
    type = "SystemAssigned"
  }
  client_cert_mode = var.client_cert_mode
  app_settings = merge({ "APPINSIGHTS_INSTRUMENTATIONKEY" = var.instrumentation_key }, var.app_settings)
  
  site_config {

    dynamic "ip_restriction" {
      for_each = var.ip_restriction == null ? [] : var.ip_restriction
        content {
          name            = lookup(ip_restriction.value, "name", null)
          priority        = lookup(ip_restriction.value, "priority", null)
          service_tag     = lookup(ip_restriction.value, "service_tag", null)
          ip_address      = lookup(ip_restriction.value, "ip_address", null)
          action          = lookup(ip_restriction.value, "action", null)
        }
      }
    ftps_state   = var.ftps_state
   }
}

resource "azurerm_app_service_virtual_network_swift_connection" "functionapp_vnet" {
  count          = var.create_vnet_swift_conn == true ? 1 : 0
  app_service_id = azurerm_function_app.functionapp.id
  subnet_id      = var.vnet_integration_subnet_id
}

resource "azurerm_private_endpoint" "pep" {
  count               = var.create_private_endpoint == true ? 1 : 0
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.private_endpoint_name}-sc"
    private_connection_resource_id = azurerm_function_app.functionapp.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }
}
