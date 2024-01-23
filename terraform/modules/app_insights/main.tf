resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.log_analytics_workspace
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  tags                = var.tags 
  lifecycle {
     ignore_changes = [sku]
   }
}

resource "azurerm_application_insights" "app_insights" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  application_type    = "web"
  tags                = var.tags 
}