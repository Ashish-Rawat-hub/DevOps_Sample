variable "webapp_name" {
  description = "Webapp name"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "resource_group_location" {
  description = "Resource group location"
}

variable "service_plan_id" {
    description = "Webapp Service plan id"
}

variable "current_stack" {
  description = "Current stack"
  default = "dotnet"
}

variable "dotnet_version" {
  description = "Dotnet version"
  default = "v6.0"
}

variable "tags" {
  description = "tags"
}

variable "app_insights_intrumentation_key" {
  description = "App insighs intrumentation key to link it to app insight"
  default = ""
}

variable "client_certificate_enabled" {
  description = "Should Client Certificates be enabled?"
  type = bool
  default = false
}

variable "auth_settings_enable" {
  description = "Boolean to decide if the Authentication / Authorization feature is enabled for the Windows Web App be enabled?"
  type        = bool
  default     = true
}
variable "ui_webapp_url" {
  description = "URL of webapp to be added to allowed origins"
  default = []
}

variable "app_settings" {
  description = "A key-value pair of App Settings"
  type        = map(any)
}

variable "app_service_connection_string" {
  description = "Connection string of the app service"
  default = []
}

variable "create_vnet_swift_conn" {
  description = "Bool to choose whether to enable vnet integration or not"
  default = false
}

variable "app_service_vnet_integration_subnet_id" {
  description = "Subnet id of the vnet to be integrated with this webapp"
  default = ""
}

variable "vnet_route_all_enabled" {
  description = "Should all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied?"
  default = true
}

variable "ip_restriction" {
  description = "Describe the IP restriction block"
  default = []  
}