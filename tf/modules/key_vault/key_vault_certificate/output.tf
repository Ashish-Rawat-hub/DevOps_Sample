output "apim_certificate_thumbprint" {
  value = azurerm_key_vault_certificate.keyvault_cert[0].thumbprint
}