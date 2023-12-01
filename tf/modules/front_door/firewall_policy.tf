resource "azurerm_cdn_frontdoor_firewall_policy" "policy" {
  name                              = var.frontdoor_firewall_policy_name
  resource_group_name               = var.resource_group_name
  sku_name                          = azurerm_cdn_frontdoor_profile.front_door_profile.sku_name
  enabled                           = true
  mode                              = "Prevention"
  custom_block_response_status_code = 403
  custom_block_response_body        = "cmVxdWVzdCBub3QgYXV0aG9yaXNlZCBlbmNvZGUK"
  tags                              = var.tags

  custom_rule {
    name                           = "ThrottlingRule"
    enabled                        = true
    priority                       = 1
    rate_limit_duration_in_minutes = 5
    rate_limit_threshold           = 100
    type                           = "RateLimitRule"
    action                         = "Block"

    match_condition {
      match_variable     = "RequestUri"
      operator           = "Contains"
      negation_condition = false
      match_values       = ["/testing", "/testing_reports", "/testing_template/create", "/testing_template/search", "/transaction_logs"]
    }
  }

  custom_rule {
    name                           = "GEOLocationFilter"
    enabled                        = true
    priority                       = 2
    rate_limit_duration_in_minutes = 0
    rate_limit_threshold           = 0
    type                           = "MatchRule"
    action                         = "Block"

    match_condition {
      match_variable     = "SocketAddr"
      operator           = "GeoMatch"
      negation_condition = true
      match_values       = ["US", "IN"]
    }
  }
  
  custom_rule {
    name                           = "IPWhiteListingRule"
    enabled                        = true
    priority                       = 3
    type                           = "MatchRule"
    action                         = "Allow"

    match_condition {
      match_variable     = "RemoteAddr"
      operator           = "IPMatch"
      negation_condition = true
      match_values       = ["0.0.0.0/0"]
    }
  }  
}

resource "azurerm_cdn_frontdoor_security_policy" "security_policy" {
  name                     = var.frontdoor_security_policy_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.front_door_profile.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.policy.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.front_door_endpoint.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}