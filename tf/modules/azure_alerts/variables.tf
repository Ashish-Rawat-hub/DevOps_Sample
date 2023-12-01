variable "tags" {
  description = "Extra tags to add."
  type        = map(string)
}

variable "resource_group_name" {
  type = string
  description = "Name of Resource Group"
}

variable "scope" {
  description = "(Required) azurerm monitor activity log scope"
  type = string
}

variable "resource_id" {
  description = "Resource ID"
}

variable "alert_name" {
  type = string
  description = "List of Alerts"
}

variable "alert_description" {
  description = "Alert Description"
}

variable "action_group_id" {
  description = "action group id"
}