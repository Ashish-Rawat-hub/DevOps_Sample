resource "azurerm_key_vault_secret" "kv_secrets" {
  for_each     = var.kv_secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
}