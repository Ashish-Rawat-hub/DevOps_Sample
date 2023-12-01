# Create an API
resource "azurerm_api_management_api" "api" {
  api_management_name   = var.apim_name
  resource_group_name   = var.apim_resource_group_name
  display_name          = var.display_name
  name                  = var.name
  revision              = var.revision
  protocols             = ["https"]
}
