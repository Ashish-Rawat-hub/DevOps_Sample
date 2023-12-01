resource "azurerm_key_vault_access_policy" "readers_policy" {
  for_each     = toset(var.reader_objects_ids)
  object_id    = each.value
  tenant_id    = var.tenant_id
  key_vault_id = join(",", azurerm_key_vault.keyvault.*.id)

  key_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]

  certificate_permissions = [
    "Get",
    "List",
  ]
}

resource "azurerm_key_vault_access_policy" "admin_policy" {
  for_each     = toset(var.admin_objects_ids)
  object_id    = each.value
  tenant_id    = var.tenant_id
  key_vault_id = join(",", azurerm_key_vault.keyvault.*.id)

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update",
  ]
}

resource "azurerm_key_vault_access_policy" "service_principal_policy" {
  
  tenant_id = var.tenant_id
  object_id = var.object_id
  key_vault_id = join(",", azurerm_key_vault.keyvault.*.id)

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Restore",
  ]

  secret_permissions = [
    "Set",
    "Get",
    "Delete",
    "Purge",
    "Recover"
  ]

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Update",
  ]
}