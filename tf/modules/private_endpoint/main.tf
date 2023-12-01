resource "azurerm_private_endpoint" "pe" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name}-pe-connection"
    is_manual_connection           = lookup(var.private_service_connection, "is_manual_connection", null)
    private_connection_resource_id = lookup(var.private_service_connection, "private_connection_resource_id", null)
    subresource_names              = lookup(var.private_service_connection, "subresource_names", null)
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_group != null ? var.private_dns_zone_group : {}
    content {
      name                 = private_dns_zone_group.value.name
      private_dns_zone_ids = private_dns_zone_group.value.private_dns_zone_ids
    }
  }

  tags = var.tags
}