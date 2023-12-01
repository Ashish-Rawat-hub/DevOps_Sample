output "key_vault_secrets" {
  description = "The ids of key vaults secrets"
  value = tomap({
    for k, v in azurerm_key_vault_secret.key_vault_secret : k => {
      id   = v.id
      resource_id = v.resource_id
      version = v.version
      value   = v.value
    }
  })
}