variable "location" {
 description = "Application insight location" 
}

variable "resource_group_name" {
 description = "Application insight's resource group name" 
}

variable "app_insights_workspace_name" {
  description = "App insight workspace name"
}

variable "log_analytics_workspace_sku" {
  description = "App insight workspace SKU"
}

variable "retention_in_days" {
  description = "Log retention days"
}

variable "tags" {
  description = "tags"
}