variable "resource_group_name" {
  description = "Resource Group the resources will belong to"
  type        = string
}

variable "location" {
  description = "Azure location for Key Vault."
  type        = string
}

variable "log_analytics_workspace" {
  description = "log_analytics_workspace"
  type        = string
}

variable "application_insights_name" {
  description = "application_insights_name"
  type        = string
}

variable "sku" {
  description = "sku"
  type        = string
  default     = "Standalone"
}

variable "tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}