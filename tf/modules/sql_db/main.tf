resource "azurerm_mssql_database" "mssql_database" {
  name           = var.name
  server_id      = var.server_id
  #collation      = "SQL_Latin1_General_CP1_CI_AS"
  #license_type   = "LicenseIncluded"
  max_size_gb    = 2
  #read_scale     = true
  sku_name       = var.sku_name
  #zone_redundant = true
  tags = var.tags
}