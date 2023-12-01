resource "azurerm_windows_web_app" "main" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id

  https_only           = var.https_only
  app_settings         = var.app_settings

  dynamic "site_config" {
    for_each = [var.site_config]

    content {

      ftps_state    = lookup(site_config.value, "ftps_state", null)
      always_on     = lookup(site_config.value, "always_on", null)
      http2_enabled = lookup(site_config.value, "http2_enabled", null)
      vnet_route_all_enabled = lookup(site_config.value, "vnet_route_all_enabled", null)
      websockets_enabled     = lookup(site_config.value, "websockets_enabled", null) 

      application_stack {
        current_stack     = lookup(site_config.value, "current_stack", null)
        dotnet_version    = lookup(site_config.value, "dotnet_version", null)
      }

      virtual_application {
          physical_path    = lookup(site_config.value, "physical_path", null)
          preload          = lookup(site_config.value, "preload", null)
          virtual_path     = lookup(site_config.value, "virtual_path", null)
      }

      dynamic "ip_restriction" {
        for_each = var.ip_restriction == null ? [] : var.ip_restriction
        content {
          name            = lookup(ip_restriction.value, "name", null)
          priority        = lookup(ip_restriction.value, "priority", null)
          service_tag     = lookup(ip_restriction.value, "service_tag", null)
          action          = lookup(ip_restriction.value, "action", null)
        }
      }

    }
  }

  identity {
    type         = local.identity.type
    identity_ids = local.identity.ids
  }
  lifecycle {
    ignore_changes = [ virtual_network_subnet_id ]
  }
  tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_service_vnet_integration" {
  count          = var.create_vnet_swift_conn == true ? 1 : 0
  app_service_id = azurerm_windows_web_app.main.id
  subnet_id      = var.app_service_vnet_integration_subnet_id
  depends_on = [
    azurerm_windows_web_app.main
  ]
}

resource "azurerm_private_endpoint" "pep" {
  count               = var.create_private_endpoint == true ? 1 : 0
  name                = "appservice-pep"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "appservice-pep-sc"
    private_connection_resource_id = azurerm_windows_web_app.main.id
    is_manual_connection           = var.private_endpoint_manual_connection
    subresource_names              = var.private_endpoint_subresource_names
  }

  depends_on = [
    azurerm_windows_web_app.main
  ]

  tags = var.tags
}
