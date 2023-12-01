locals {
  front_door_profile_name      = var.front_door_name
  front_door_endpoint_name     = "${var.front_door_name}-endpoint"
  front_door_origin_group_name = "${var.front_door_name}-group"
  front_door_origin_name       = "${var.front_door_name}-origin"
  front_door_route_name        = "${var.front_door_name}-route"
}

resource "azurerm_cdn_frontdoor_profile" "front_door_profile" {
  name                = local.front_door_profile_name
  resource_group_name = var.resource_group_name
  sku_name            = var.front_door_sku_name
  tags                = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "front_door_endpoint" {
  name                     = local.front_door_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  tags                     = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "front_door_origin_group" {
  name                     = local.front_door_origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id
  session_affinity_enabled = true

  dynamic "load_balancing" {
    for_each = var.front_door_load_balancing
      content {
        sample_size                 = lookup(load_balancing.value, "sample_size", 4)
        successful_samples_required = lookup(load_balancing.value, "successful_samples_required", 3)
      }
  }

  dynamic "health_probe" {
    for_each = var.front_door_health_probe
      content {
        path                = lookup(health_probe.value, "path", "/")
        request_type        = lookup(health_probe.value, "request_type", "HEAD")
        protocol            = lookup(health_probe.value, "protocol", "Https")
        interval_in_seconds = lookup(health_probe.value, "interval_in_seconds", 100)
      }
  }
}

resource "azurerm_cdn_frontdoor_origin" "front_door_service_origin" {
  name                          = local.front_door_origin_name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.front_door_origin_group.id

  enabled                        = true
  host_name                      = var.frontend_backend_host
  http_port                      = var.frontdoor_origin_http_port
  https_port                     = var.frontdoor_origin_https_port
  origin_host_header             = var.frontend_backend_host
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = var.certificate_name_check_enabled
}

resource "azurerm_cdn_frontdoor_route" "my_route" {
  name                          = local.front_door_route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.front_door_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.front_door_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.front_door_service_origin.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}





















# # Create front door
# resource "azurerm_frontdoor" "front_door" {
#   name                                         = var.front_door_name
#   resource_group_name                          = var.resource_group_name
#   load_balancer_enabled                        = var.load_balancer_enabled
#   tags                                         = var.tags

#   backend_pool_settings {
#     enforce_backend_pools_certificate_name_check = var.certificate_name_check
#     backend_pools_send_receive_timeout_seconds   = var.backend_timeout_seconds
#   }

#     dynamic "backend_pool_load_balancing" {
#     for_each = var.front_door_load_balancing
#         content {
#             name                            = lookup(backend_pool_load_balancing.value, "name", "loadbalancer")
#             sample_size                     = lookup(backend_pool_load_balancing.value, "sample_size", "4")
#             successful_samples_required     = lookup(backend_pool_load_balancing.value, "successful_samples_required", "2")
#             additional_latency_milliseconds = lookup(backend_pool_load_balancing.value, "additional_latency_milliseconds", "0")
#         }
#     }

#     dynamic "frontend_endpoint" {
#     for_each    = var.frontend_endpoint
#         content {
#             name                                    = var.front_door_name #lookup(frontend_endpoint.value, "name", "my-frontdoor-fe-endpoint")
#             host_name                               = lookup(frontend_endpoint.value, "host_name", "my-frontdoor.azurefd.net")
#             session_affinity_enabled                = lookup(frontend_endpoint.value, "session_affinity_enabled", false)
#             session_affinity_ttl_seconds            = lookup(frontend_endpoint.value, "session_affinity_ttl_seconds", 0)
#         }
#     }

#     dynamic "routing_rule" {
#         for_each = var.frontdoor_routing_rule
#         content {
#             name               = lookup(routing_rule.value, "name", "my-routing-rule")
#             accepted_protocols = lookup(routing_rule.value, "accepted_protocols", "https")
#             patterns_to_match  = lookup(routing_rule.value, "patterns_to_match", "")
#             frontend_endpoints = values({for x, endpoint in var.frontend_endpoint : x => endpoint.name})
#             dynamic "forwarding_configuration" {
#                 for_each = lookup(routing_rule.value, "forwarding_configuration", [])
#                 content {
#                     backend_pool_name                     = lookup(forwarding_configuration.value, "backend_pool_name", "backendBing")
#                     cache_enabled                         = lookup(forwarding_configuration.value, "cache_enabled", false)
#                     cache_use_dynamic_compression         = lookup(forwarding_configuration.value, "cache_use_dynamic_compression", false)
#                     cache_query_parameter_strip_directive = lookup(forwarding_configuration.value, "cache_query_parameter_strip_directive", "StripNone")
#                     custom_forwarding_path                = lookup(forwarding_configuration.value, "custom_forwarding_path", "")
#                     forwarding_protocol                   = lookup(forwarding_configuration.value, "forwarding_protocol", "MatchRequest")
#                 }
#             }
#             dynamic "redirect_configuration" {
#                 for_each = lookup(routing_rule.value, "redirect_configuration", [])
#                 content {
#                     custom_host         = lookup(redirect_configuration.value, "custom_host", "")
#                     redirect_protocol   = lookup(redirect_configuration.value, "redirect_protocol", "")
#                     redirect_type       = lookup(redirect_configuration.value, "redirect_type", "")
#                     custom_fragment     = lookup(redirect_configuration.value, "custom_fragment", "")
#                     custom_path         = lookup(redirect_configuration.value, "custom_path", "")
#                     custom_query_string = lookup(redirect_configuration.value, "custom_query_string", "")
#                 }
#             }
#         }
#     }

#     dynamic "backend_pool_health_probe" {
#     for_each = var.front_door_health_probe
#         content {
#             name                = lookup(backend_pool_health_probe.value, "name", "healthprobe")
#             enabled             = lookup(backend_pool_health_probe.value, "enabled", true)
#             path                = lookup(backend_pool_health_probe.value, "path", "/")
#             protocol            = lookup(backend_pool_health_probe.value, "protocol", "Http")
#             probe_method        = lookup(backend_pool_health_probe.value, "probe_method", "HEAD")
#             interval_in_seconds = lookup(backend_pool_health_probe.value, "interval_in_seconds", 60)
#         }
#     }


#     dynamic "backend_pool" {
#     for_each = var.frontdoor_backend
#         content {
#             name                = lookup(backend_pool.value, "name", "backendBing")
#             load_balancing_name = lookup(backend_pool.value, "load_balancing_name", "loadbalancer")
#             health_probe_name   = lookup(backend_pool.value, "health_probe_name", "healthprobe")
        
#             dynamic "backend" {
#             for_each = lookup(backend_pool.value, "backend", [])
#                 content {
#                     enabled     = lookup(backend.value, "enabled", true)
#                     address     = var.frontend_backend_host #lookup(backend.value, "address", "www.bing.com")
#                     host_header = var.frontend_backend_host #lookup(backend.value, "host_header", "www.bing.com")
#                     http_port   = lookup(backend.value, "http_port", 80)
#                     https_port  = lookup(backend.value, "https_port", 443)
#                     priority    = lookup(backend.value, "priority", 1)
#                     weight      = lookup(backend.value, "weight", 50)
#                 }
#             }
#         }
#     }
#}