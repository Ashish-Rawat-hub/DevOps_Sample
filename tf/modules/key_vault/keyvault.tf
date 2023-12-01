resource "azurerm_key_vault" "keyvault" {
  count                           = var.create_key_vault ? 1 : 0 
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  #enabled_for_deployment          = var.enabled_for_deployment
  #enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  #enabled_for_template_deployment = var.enabled_for_template_deployment
  #enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [var.network_acls]
    iterator = acl

    content {
      bypass                     = coalesce(acl.value.bypass, "None")
      default_action             = coalesce(acl.value.default_action, "Deny")
      ip_rules                   = acl.value.ip_rules
      virtual_network_subnet_ids = acl.value.virtual_network_subnet_ids #var.virtual_network_subnet_ids
    }
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "keyvault_pep" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "${var.name}-pep"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-sc"
    is_manual_connection           = false
    private_connection_resource_id = join(",", azurerm_key_vault.keyvault.*.id)
    subresource_names              = ["vault"]
  }

  tags = var.tags
}