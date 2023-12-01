resource "azurerm_windows_web_app" "webapp" {
  name                = var.webapp_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  service_plan_id     = var.service_plan_id
  client_certificate_enabled = false #var.client_certificate_enabled
  auth_settings {
     enabled = true
     unauthenticated_client_action = "AllowAnonymous" # Sensitive
  }
  tags = var.tags

  client_affinity_enabled = true
  https_only              = true
  site_config {
    dynamic "cors" {
      for_each = length(var.ui_webapp_url) > 0 ? [1] : []
      content {
        allowed_origins = var.ui_webapp_url
      }
    }
    dynamic "ip_restriction" {
      for_each = var.ip_restriction
      content {
        name                            = ip_restriction.value["name"]
        priority                        = ip_restriction.value["priority"]
        virtual_network_subnet_id       = ip_restriction.value["virtual_network_subnet_id"]
        ip_address                      = ip_restriction.value["ip_address"]
        action                          = ip_restriction.value["action"]
      }
    }    
    ftps_state = "FtpsOnly"
    always_on  = false

    application_stack {
      current_stack  = var.current_stack
      dotnet_version = var.dotnet_version
    }

    vnet_route_all_enabled = var.vnet_route_all_enabled

    virtual_application {
      physical_path = "site\\wwwroot"
      preload       = false
      virtual_path  = "/"
    }
  }
  dynamic "connection_string" {
    for_each = var.app_service_connection_string
    content {
      name  = connection_string.value["name"]
      type  = connection_string.value["type"]
      value = connection_string.value["value"]
    }
  }
  app_settings = var.app_settings

  virtual_network_subnet_id = var.app_service_vnet_integration_subnet_id == "" ? null : var.app_service_vnet_integration_subnet_id
  identity {
    type = "SystemAssigned"
  }
}