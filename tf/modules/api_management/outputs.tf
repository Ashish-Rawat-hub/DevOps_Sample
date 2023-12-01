output "api_management_name" {
  description = "The name of the API Management Service"
  value       = azurerm_api_management.apim.name
}

output "api_management_id" {
  description = "The ID of the API Management Service"
  value       = azurerm_api_management.apim.id
}

output "apim_public_ip_addresses" {
  description = "Public Ip of the API Management Service"
  value       = azurerm_api_management.apim.public_ip_addresses
}

output "apim_gateway_url" {
  description = "Gateway URL of the API Management"
  value = azurerm_api_management.apim.gateway_url
}

output "apim_identity" {
  description = "System Assigned Identity of Api Management"
  value = azurerm_api_management.apim.identity
}

output "apim_subscription_key" {
  value = azurerm_api_management_subscription.apim_subscription.primary_key
}