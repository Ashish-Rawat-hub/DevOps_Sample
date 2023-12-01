variable "resource_group_name" {
  description = "(Required) Resource Group name"
  type = string
}
 
variable "front_door_name" {
  description = "(Required) Name of the Azure Front Door to create"
  type = string
}

variable "front_door_sku_name" {
  description = "(Required) Name of the Azure Front Door sku to create"
  type = string
}

variable "front_door_load_balancing" {
  description = "(Required) Load Balancer settings for Azure Front Door"
}

variable "front_door_health_probe" {
  description = "(Required) Health Probe settings for Azure Front Door"
}

variable "frontend_backend_host" {
  description = "(Required) Routing rules for Azure Front Door"
  default = "www.microsoft.com"
}

variable "frontdoor_origin_http_port" {
  description = "(Required) frontdoor origin http port"
  default = 80
}

variable "frontdoor_origin_https_port" {
  description = "(Required) frontdoor origin https port"
  default = 443
}

variable "certificate_name_check_enabled" {
  description = "frontdoor origin certificate name check enabled"
  default = false
}

variable "frontdoor_firewall_policy_name" {
  description = "(Required) Firewall policy name"
}

variable "frontdoor_security_policy_name" {
  description = "Frontdoor security policy name"
}

variable "tags" {
  description = "(Required) Tags for Azure Front Door" 
}


# variable "certificate_name_check" {
#   description = "Enforce the certificate name check for Azure Front Door"
#   type = bool
#   default = false
# }

# variable "load_balancer_enabled" {
#   description = "(Required) Enable the load balancer for Azure Front Door"
#   type = bool
# }
 
# variable "backend_timeout_seconds" {
#   description = "Set the send/receive timeout for Azure Front Door"
#   type = number
#   default = 60
# }


# variable "frontend_endpoint" {
#   description = "(Required) Frontend Endpoints for Azure Front Door"
# }
 
# variable "frontdoor_routing_rule" {
#   description = "(Required) Routing rules for Azure Front Door"
# }



# variable "forwarding_configuration" {
#   description = "(Required) Routing rules for Azure Front Door"
# }
 
# variable "frontdoor_backend" {
#   description = "(Required) Backend settings for Azure Front Door"
# }

# variable "backend" {
#   description = "(Required) Backend settings for Azure Front Door"
# }

