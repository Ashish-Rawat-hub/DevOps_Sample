data "azurerm_client_config" "current" {}

data "azuread_service_principal" "current" {
  object_id = var.service_principal_id
}

locals {
    sp_object_id = data.azuread_service_principal.current.object_id
    tenant_id    = data.azurerm_client_config.current.tenant_id

    registry_details = [{
      "container_app_registry_identity" = "system"
      "container_registry_server"       = module.container_registry["dev"].server_hostname
    }]
}