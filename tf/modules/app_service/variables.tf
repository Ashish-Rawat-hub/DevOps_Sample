variable "tags" {
  description = "Extra tags to add."
  type        = map(string)
}

variable "location" {
  description = "Location of the app service"
  type        = string
}


variable "resource_group_name" {
  description = "Resource group for the app service"
  type        = string
}

variable "app_service_name" {
  description = "Name for the app service"
  #type        = string
}

variable "app_service_plan_id" {
  description = "Resource ID for the app service plan"
  type        = string
}

variable "app_service_vnet_integration_subnet_id" {
  description = "Resource ID for the subnet to integrate into"
  type        = string
}

variable "https_only" {
  description = "Can the App Service only be accessed via HTTPS?"
  type        = bool
}

variable "http2_enabled" {
  description = "Enables HTTP2 on the App Service"
  default = true
}

variable "always_on" {
  type       = bool
  default    = false 
}

variable "identity" {
  description = "Authentication settings for the app service"
  type        = map(any)
}

variable "dotnet_version" {
  description = "dotnet version"
  type        = string
}

variable "current_stack" {
  description = "App configuration block"
  type        = string
  default = "dotnet"
}

variable "app_settings" {
  description = "A key-value pair of App Settings"
  type        = map(any)
}

variable "site_config" {
  description = "App configuration block"
  type        = any
}

variable "create_vnet_swift_conn" {
  description = "Toggle for create vnet swift connection or not"
  type        = bool
}

variable "create_private_endpoint" {
  description = "Toggle should we create the private endpoint for this app service?"
  type        = bool
} 

variable "private_endpoint_subnet_id" {
  description = "Subnet ID the private endpoint to connect to"
  type        = string
} 

variable "private_endpoint_manual_connection" {
  description = "Toggle is this private endpoint a manual connection?"
  type        = bool
} 

variable "private_endpoint_subresource_names" {
  description = "List of subresources you want the private endpoint to connect to"
  type        = list(string)
} 

variable "private_endpoint_private_dns_zone_group" {
  description = "DNS zone group block"
  type        = map(string)
}

variable "ftps_state" {
  description = "State of FTP / FTPS service for the app.service"
  default     = "FtpsOnly"
}

variable "vnet_route_all_enabled" {
  description = "Should all outbound traffic to have NAT Gateways, Network Security Groups and User Defined Routes applied?"
  type        = bool
  default     = "false"
}

variable "key_vault_id" {
  type = any
  description = "Key Vault ID"
  default     = null
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  default     = ""
}

variable "ip_restriction" {
  description = "App service public network access Ip Restriction"
  type        = list(any)
  default     = []
}

# variable "virtual_application" {
#   description = "App Service Site config virtual Application"
#   type        = any
# }