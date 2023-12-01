
data "azurerm_key_vault_secret" "CosmosDbAccount" {
  name         = "CosmosDbAccount"
  key_vault_id = var.master_key_vault_id
}

data "azurerm_key_vault_secret" "CosmosDbConnectionString" {
  name         = "CosmosDbConnectionString"
  key_vault_id = var.master_key_vault_id
}

data "azurerm_key_vault_secret" "CosmosDbKey" {
  name         = "CosmosDbKey"
  key_vault_id = var.master_key_vault_id
}

data "azurerm_key_vault_secret" "CosmosDbName" {
  name         = "CosmosDbName"
  key_vault_id = var.master_key_vault_id
}


data "azurerm_key_vault_secret" "TokenClientId" {
  name         = "TokenClientId"
  key_vault_id = var.master_key_vault_id
}

data "azurerm_key_vault_secret" "TokenClientSecret" {
  name         = "TokenClientSecret"
  key_vault_id = var.master_key_vault_id
}

data "azurerm_key_vault_secret" "VelaNetworkOcpApimKey" {
  name         = "VelaNetworkOcpApimKey"
  key_vault_id = var.master_key_vault_id
}

data "azurerm_key_vault_secret" "VelaNetworkURL" {
  name         = "VelaNetworkURL"
  key_vault_id = var.master_key_vault_id
}

data "azurerm_key_vault_secret" "VelaNetworkOcpApimKeyEMR" {
  name         = "VelaNetworkOcpApimKeyEMR"
  key_vault_id = var.master_key_vault_id
}

locals {
 
    key_vault_modules_secrets = [
    {
      name             = "CosmosDbAccount"
      value            = data.azurerm_key_vault_secret.CosmosDbAccount.value      
    },
    {
      name             = "CosmosDbConnectionString"
      value            = data.azurerm_key_vault_secret.CosmosDbConnectionString.value     
    },
    {
      name             = "CosmosDbKey"
      value            = data.azurerm_key_vault_secret.CosmosDbKey.value     
    },
    {
      name             = "CosmosDbName"
      value            = data.azurerm_key_vault_secret.CosmosDbName.value     
    },
    {
      name             = "TokenClientId"
      value            = data.azurerm_key_vault_secret.TokenClientId.value     
    },
    {
      name             = "TokenClientSecret"
      value            = data.azurerm_key_vault_secret.TokenClientSecret.value      
    },
    {
      name             = "VelaNetworkOcpApimKey"
      value            = data.azurerm_key_vault_secret.VelaNetworkOcpApimKey.value      
    },
    {
      name             = "VelaNetworkURL"
      value            = data.azurerm_key_vault_secret.VelaNetworkURL.value      
    },
    {
      name             = "VelaNetworkOcpApimKeyEMR"
      value            = data.azurerm_key_vault_secret.VelaNetworkOcpApimKeyEMR.value
    }
  ]

  vault_secrets = var.fetch_master_key_vault_secrets == false ? [] : concat(local.key_vault_modules_secrets, var.key_vault_secrets)
  depends_on = [azurerm_key_vault_access_policy.service_principal_policy]
}



resource "azurerm_key_vault_secret" "key_vault_secret" {
  for_each        = { for sec in local.vault_secrets : sec.name => sec }
  name            = each.value.name
  value           = each.value.value
  key_vault_id    = join(",", azurerm_key_vault.keyvault.*.id)
  expiration_date = var.secret_expiration_date

  depends_on = [azurerm_key_vault_access_policy.service_principal_policy]
}
