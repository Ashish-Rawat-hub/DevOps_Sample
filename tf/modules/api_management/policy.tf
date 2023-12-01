resource "azurerm_key_vault_access_policy" "readers_policy" {
  object_id    = azurerm_api_management.apim.identity.0.principal_id
  tenant_id    = var.tenant_id
  key_vault_id = var.key_vault_id

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