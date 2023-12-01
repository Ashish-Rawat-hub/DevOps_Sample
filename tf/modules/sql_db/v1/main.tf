data "azurerm_mssql_server" "sql_server" {
  count               = var.create_sql_db == true ? 1 : 0
  name                = var.sqlservername
  resource_group_name = var.resource_group_name
}
resource "azurerm_mssql_database" "sqldb" {
  count          = var.create_sql_db == true ? 1 : 0
  name           = var.sql_db_name
  server_id      = data.azurerm_mssql_server.sql_server[0].id
  collation      = var.collation
  license_type   = var.license_type
  read_scale     = var.read_scale
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
  create_mode    = var.create_secondary_db == true ? "Secondary" : "Default"
  creation_source_database_id = var.create_secondary_db == true ? var.primary_sqldb_id : null

  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy == null ? [] : var.threat_detection_policy
    content {
      state                      = lookup(threat_detection_policy.value, "state", "Enabled")
      disabled_alerts            = toset(lookup(threat_detection_policy.value, "disabled_alerts", []))
      email_account_admins       = lookup(threat_detection_policy.value, "email_account_admins", "Enabled")
      email_addresses            = lookup(threat_detection_policy.value, "email_addresses", "")
      retention_days             = lookup(threat_detection_policy.value, "retention_days", 6)
      storage_account_access_key = lookup(threat_detection_policy.value, "storage_account_access_key", "")
      storage_endpoint           = lookup(threat_detection_policy.value, "storage_endpoint", "")
    }
  }

  tags = var.tags
}