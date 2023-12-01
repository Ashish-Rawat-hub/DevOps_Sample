resource "azurerm_storage_account" "storage_account" {
  name                       = var.storage_account_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_kind               = var.account_kind
  account_tier               = var.account_tier
  account_replication_type   = var.account_replication_type
  enable_https_traffic_only  = true
  min_tls_version            = var.min_tls_version
  shared_access_key_enabled  = var.shared_access_key_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public

  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []

    content {
      default_action             = var.network_rules.default_action
      bypass                     = var.network_rules.bypass
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids
    }
  }

  tags                       = merge({ "ResourceName" = var.storage_account_name }, var.tags, )

}

resource "azurerm_private_dns_zone" "sa_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags = var.tags
}

resource "azurerm_private_endpoint" "pep" {
  for_each            = var.private_endpoints_config
  name                = "${var.storage_account_name}-${each.key}-pep"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

 

  private_service_connection {
    name                           = "${var.storage_account_name}-sc"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = each.value.is_manual_connection
    subresource_names              = each.value.subresource_names
  }

 

  private_dns_zone_group {
    name                 = each.value.dnszonegroup_name
    private_dns_zone_ids = azurerm_private_dns_zone.sa_dns_zone.*.id
  }
  tags = var.tags
}



resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_vnet_link" {
  #count                 = var.create_private_endpoint == true ? 1 : 0
  name                  = var.virtual_network_private_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sa_dns_zone.name
  virtual_network_id    = var.virtual_network_id
  tags = var.tags
}