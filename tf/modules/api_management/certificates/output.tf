output "apim_certificate_thumbprint" {
  value = azurerm_api_management_certificate.certificate[0].thumbprint
}