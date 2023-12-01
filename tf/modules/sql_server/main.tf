data "azurerm_client_config" "current" {}

data "azuread_service_principal" "current" {
  display_name = var.principal_display_name
}

data "azurerm_mssql_server" "sql_server" {
  count               = var.create_sql_server == false ? 1 : 0
  name                = var.mssql_server_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_mssql_server" "sqlserver" {
  count                        = var.create_sql_server == true ? 1 : 0  
  name                         = var.mssql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.mssql_server_version
  minimum_tls_version          = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  azuread_administrator {
    azuread_authentication_only = var.enable_aad_authentication_only
    login_username = data.azuread_service_principal.current.display_name
    object_id      = data.azuread_service_principal.current.object_id
  }
  tags                          = var.tags
}

resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" { 
   count               = var.create_sql_server == true && var.create_virtual_network_rule == true && var.public_network_access_enabled == true ? 1 : 0
  name                = var.sql_virtual_network_rule_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.sqlserver[0].name
  subnet_id           = var.sql_virtual_network_rule_subnet_id
}

resource "azurerm_private_endpoint" "pep" {
  count               = var.create_sql_server == true && var.create_private_endpoint == true ? 1 : 0
  name                = var.sql_virtual_network_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = var.sql_virtual_network_endpoint_name
    private_connection_resource_id = azurerm_mssql_server.sqlserver[0].id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
      name                 = var.private_dns_zone_group_name
      private_dns_zone_ids = azurerm_private_dns_zone.sql_dns_zone.*.id 
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "sql_dns_zone" {
  count               = var.create_sql_server == true && var.create_private_endpoint == true ? 1 : 0
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags = var.tags
}

resource "azurerm_private_dns_a_record" "sql_a_record" {
  count               = var.create_sql_server == true && var.create_private_endpoint == true ? 1 : 0
  name                = var.sql_a_record_name
  zone_name           = join(",", azurerm_private_dns_zone.sql_dns_zone.*.name)
  resource_group_name = var.resource_group_name
  ttl                 = var.dns_a_record_ttl
  records             = [azurerm_private_endpoint.pep.0.private_service_connection.0.private_ip_address]
  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_vnet_link" {
  count                 = var.create_sql_server == true && var.create_private_endpoint == true ? 1 : 0
  name                  = var.virtual_network_private_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  tags = var.tags
  depends_on = [ azurerm_private_dns_zone.sql_dns_zone ]
}

resource "azurerm_sql_firewall_rule" "firewall_rule" {
  count               = var.create_sql_server == true && var.public_network_access_enabled == true ? 1 : 0
  name                = "Allow Azure Services"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.sqlserver[0].name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_storage_container" "log_container" {
  count                 = var.create_sql_server == true && var.create_assessment ? 1 : 0
  name                  = var.storage_container_name
  storage_account_name  = var.storage_account_name
  container_access_type = var.storage_container_access_type
}

resource "azurerm_mssql_server_extended_auditing_policy" "auditing" {
  count                                   = var.create_sql_server == true && var.create_assessment ? 1 : 0
  server_id                               = azurerm_mssql_server.sqlserver[0].id
  storage_endpoint                        = var.storage_endpoint
  storage_account_access_key              = var.storage_account_access_key
  storage_account_access_key_is_secondary = var.storage_account_access_key_is_secondary
  retention_in_days                       = var.retention_in_days
}

resource "azurerm_mssql_server_security_alert_policy" "alert_policy" {
  count               = var.create_sql_server == true && var.create_assessment ? 1 : 0
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.sqlserver[0].name
  state               = var.alert_policy_state
}

resource "azurerm_mssql_server_vulnerability_assessment" "assessment" {
  count                           = var.create_sql_server == true &&  var.create_assessment ? 1 : 0
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.alert_policy[0].id
  storage_container_path          = "${var.storage_endpoint}${azurerm_storage_container.log_container[0].name}/"
  storage_account_access_key      = var.storage_account_access_key

  recurring_scans {
    enabled                   = var.recurring_scans_enabled
    email_subscription_admins = var.recurring_email_subscription_admins
    emails                    = var.recurring_emails
  }
  depends_on = [ azurerm_mssql_server_security_alert_policy.alert_policy ]
}

resource "azurerm_mssql_server_extended_auditing_policy" "log_monitoring" {
  count                  = var.create_sql_server == true ? 1 : 0
  server_id              = azurerm_mssql_server.sqlserver[0].id
  log_monitoring_enabled = true
}