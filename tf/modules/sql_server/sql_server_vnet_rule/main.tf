resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  count               = var.create_virtual_network_rule == true ? 1 : 0
  name                = var.sql_virtual_network_rule_name
  resource_group_name = var.resource_group_name
  server_name         = var.sql_server_name
  subnet_id           = var.sql_virtual_network_rule_subnet_id
}