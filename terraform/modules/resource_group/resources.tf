resource "azurerm_resource_group" "main_rg" {
  count    = var.create ? 1 : 0
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}