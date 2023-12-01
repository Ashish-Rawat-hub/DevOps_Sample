output "front_door_profile_id" {
  description = "Frontdoor profile id"
  value       = azurerm_cdn_frontdoor_profile.front_door_profile.id
}

output "front_door_hostname" {
  value = azurerm_cdn_frontdoor_endpoint.front_door_endpoint.host_name
}