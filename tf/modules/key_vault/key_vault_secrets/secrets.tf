data "azurerm_key_vault_secret" "kv_sec" {
  count        = length(var.master_secret_name)
  name         = var.master_secret_name[count.index]
  key_vault_id = var.master_key_vault_id
}

locals {
 
    key_vault_modules_secrets = [ for index, secret_name in var.master_secret_name :
      {
        name             = secret_name
        value            = data.azurerm_key_vault_secret.kv_sec[index].value  
      }
    ]

    vault_secrets = concat(local.key_vault_modules_secrets, var.key_vault_secrets)
}
resource "azurerm_key_vault_secret" "key_vault_secret" {
  for_each        = { for sec in local.vault_secrets : sec.name => sec }
  name            = each.value.name
  value           = each.value.value
  key_vault_id    = var.key_vault_id
  expiration_date = var.secret_expiration_date
}