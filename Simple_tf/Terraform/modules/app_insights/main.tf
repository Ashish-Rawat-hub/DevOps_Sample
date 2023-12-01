resource "azurerm_application_insights" "app_insights" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.app_type
  internet_query_enabled = var.internet_query_enabled
  internet_ingestion_enabled = var.internet_ingestion_enabled
  tags                = var.tags
}