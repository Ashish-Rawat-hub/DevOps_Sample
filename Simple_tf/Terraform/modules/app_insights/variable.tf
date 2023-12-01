variable "app_insights_name" {
 description = "Application insight name" 
}

variable "location" {
 description = "Application insight location" 
}

variable "resource_group_name" {
 description = "Application insight's resource group name" 
}

variable "app_type" {
 description = "Application insight's app type" 
}

variable "tags" {
  description = "tags"
}

variable "internet_query_enabled" {
  description = "Enable to support querying over the Public Internet"
  type        = bool
  default     = true
}

variable "internet_ingestion_enabled" {
  description = "Should the Application Insights component support ingestion over the Public Internet?"
  type        = bool
  default     = true
}