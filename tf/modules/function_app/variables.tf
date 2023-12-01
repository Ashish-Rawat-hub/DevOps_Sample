variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "location" {
  description = "(Optional) The location in which the resources will be created."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the azure storage account"
  default     = ""
}

variable "function_app_name" {
  description = "The name of the function app to be created"
  default     = ""
}

variable "function_app_name_short" {
  description = "Short name of the function apped"
  default     = ""
}

variable "app_settings" {
  description = "List of Function App app settings"
  type = map(string)
}

variable "https_only" {
  description = "When enabled, the Function App only be accessed via HTTPS"
  default = true
}

variable "app_service_plan_id" {
  description = "The name of the app service plan id to be created"
  default     = ""
}

variable "storage_account_access_key" {
  description = "Storage Account Access Key"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "extra_tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "app_service_plan_name" {
  description = "Name of the app service plan to be created"
  type        = string
  default     = ""
}
variable "app_service_plan_kind" {
  description = "Kind of app service plan"
  type = string
  default = "elastic"
}

variable "app_service_plan_size" {
  description = "Size of app service plan"
  type = string
  default = "EP1"
}

variable "app_service_plan_tier" {
  description = "Tier of app service plan"
  type = string
  default = "ElasticPremium"
}

variable "vnet_integration_subnet_id" {
  description = "Virtual Network Subnet Id"
  type = string
}

variable "app_service_plan_capacity" {
  description = "Kind of app service plan"
  type = number
  default = 1
}

variable "private_service_connection_name" {
  description = "Name of Private Service Connection"
  type = string
  default = ""
}

variable "storage_account_tier" {
  description = "Name of Storage Acciount Tier"
  type = string
  default = "Standard"
}

variable "storage_account_replication_type" {
  description = "Name of Storage Account Replication Type"
  type = string
  default = "LRS"
}

variable "private_endpoint_subnet_id" {
  description = "private endpoint subnet_id"
}

variable "private_endpoint_name" {
  description = "private endpoint name"
  default = ""
}

variable "create_private_endpoint" {
  description = "Toggle to create private endpoints for function apps"
  type        = bool
  default     = false
}

variable "function_app_version" {
  description = "Version for this function app"
  type        = string
  default     = "~1"
}

variable "app_service_environment_id" {
  description = "Id for the ase"
  type        = string
}

variable "create_vnet_swift_conn" {
  description = "Toggle for create vnet swift connection or not"
  type        = bool
}

variable "allow_ip_addresses" {
  description = "whitelist public ip addresses to access function app"
  type        = any
  default     = [] 
}

variable "instrumentation_key" {
  description = "App insights instrumentation key"
  default = ""
}

variable "ftps_state" {
  description = "State of FTP / FTPS service for the function app."
  default     = "FtpsOnly" 
}

variable "key_vault_name" {
  description = "Key vault name"
  default = ""
}

variable "key_vault_resource_group_name" {
  description = "Key vault resource group name"
  default = ""
}

variable "create_host_key_secret" {
  description = "Toggle to create secrets for function app host keys"
  type        = bool
  default     = false
}

variable "client_cert_mode" {
  description = " The mode of the Function App's client certificates requirement for incoming requests."
  type = string
  default = "Optional"
}

variable "key_vault_id" {
  type        = any
  description = "Key Vault ID"
  default     = null
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  default     = ""
}

variable "ip_restriction" {
  description = "Function App service public network access Ip Restriction"
  type        = list(any)
  default     = []
}