resource "azurerm_key_vault_access_policy" "readers_policy" {
  object_id    = azurerm_function_app.functionapp.identity.0.principal_id
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