output "key_vault_id" {
  description = "Id of the Key Vault"
  value       = join(",", azurerm_key_vault.keyvault.*.id)
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = join(",", azurerm_key_vault.keyvault.*.name)
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = join(",", azurerm_key_vault.keyvault.*.vault_uri)
}

output "key_vault_secrets" {
  description = "The ids of key vaults secrets"
  value = tomap({
    for k, v in azurerm_key_vault_secret.key_vault_secret : k => {
      id   = v.id
      resource_id = v.resource_id
      version = v.version
    }
  })
}