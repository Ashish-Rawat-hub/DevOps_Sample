resource "azurerm_service_plan" "main" {
  name                       = var.asp_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  os_type                    = var.os_type
  # app_service_environment_id = var.app_service_environment_id
  #reserved                   = var.reserved
  sku_name                   = var.sku_name

  tags = var.tags
}
