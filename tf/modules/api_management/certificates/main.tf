data "azurerm_key_vault_certificate" "certifcate" {
  count        = var.create_apim_certificate == true ? 1 : 0
  name         = var.apim_certificate_name
  key_vault_id = var.key_vault_id
}

resource "azurerm_api_management_certificate" "certificate" {
  count               = var.create_apim_certificate == true ? 1 : 0
  name                = var.apim_certificate_name
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
  key_vault_secret_id = data.azurerm_key_vault_certificate.certifcate[0].secret_id
}