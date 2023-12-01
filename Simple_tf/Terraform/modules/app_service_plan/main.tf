resource "azurerm_service_plan" "service_plan" {
  name                = var.asp_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku_name            = var.service_plan_sku
  os_type             = var.os_type
  tags = var.tags
}