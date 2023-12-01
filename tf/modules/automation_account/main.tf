resource "azurerm_automation_account" "automation_acc" {
  name                = var.automation_acc_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.automation_acc_sku
  tags                = var.tags
}