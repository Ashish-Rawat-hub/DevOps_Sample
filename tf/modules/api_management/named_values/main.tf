data "azurerm_function_app_host_keys" "default_key" {
  name                = var.function_app_name
  resource_group_name = var.function_rg_name == "" ? var.resource_group_name : var.function_rg_name
}

module "host_key_secret" {
  source = "../../key_vault/key_vault_secrets"
  key_vault_secrets = [
    {
      name  = "${var.function_app_name}-key-sec"
      value = data.azurerm_function_app_host_keys.default_key.default_function_key
    }
  ]
  key_vault_id              = var.key_vault_id
  secret_expiration_date = var.kv_secret_expiration_date
  tenant_id                 = var.tenant_id 

  depends_on = [ data.azurerm_function_app_host_keys.default_key ]
}

data "azurerm_key_vault_secret" "host_key_secret" {
  count        = var.create_named_value == true ? 1 : 0
  name         = "${var.function_app_name}-key-sec"
  key_vault_id = var.key_vault_id

  depends_on = [ module.host_key_secret ]
}

resource "azurerm_api_management_named_value" "named_values" {
  count               = var.create_named_value == true ? 1 : 0
  name                = var.named_value_name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  display_name        = var.named_value_name
  secret              = true 
  value_from_key_vault{
    secret_id = data.azurerm_key_vault_secret.host_key_secret[count.index].id
  }
  depends_on = [ data.azurerm_key_vault_secret.host_key_secret ]
}

resource "azurerm_api_management_backend" "backend" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  resource_id         = "https://management.azure.com${var.resource_id}"
  protocol            = "http"
  url                 = "https://${var.function_app_name}.azurewebsites.net/api"
  credentials {
    header = {
      
      "x-functions-key" = "{{${var.named_value_name}}}"
    }
    certificate = [var.apim_certificate_thumbprint]
  }

  depends_on = [ azurerm_api_management_named_value.named_values ]
}