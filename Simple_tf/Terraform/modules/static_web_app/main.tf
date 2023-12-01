resource "azurerm_static_site" "ui" {
  name                = var.static_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_tier            = var.static_sku_tier
  sku_size            = var.static_sku_size
  tags                = var.tags 
}

resource "azapi_resource_action" "appsetting" {
  type = "Microsoft.Web/staticSites/config@2022-03-01"
  resource_id = "${azurerm_static_site.ui.id}/config/appsettings"
  method = "PUT"

  body = jsonencode({
    properties = {
        "APPINSIGHTS_INSTRUMENTATIONKEY" = var.app_insights_intrumentation_key
        "ApiBasePath"                    = var.ApiBasePath
    }
  })
}