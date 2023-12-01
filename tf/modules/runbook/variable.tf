variable "runbook_name" {
  description = "Runbook Name"
}

variable "location" {
  description = "Runbook location"
}

variable "resource_group_name" {
  description = "Runbook resource group name"
}

variable "automation_acc_name" {
  description = "Automation account name linked to runbook"
}

variable "log_verbose" {
  description = "Runbook log verbose option"
  type = bool
  default = true
}

variable "log_progress" {
  description = "Runbook log progress option"
  type = bool
  default = true
}

variable "runbook_description" {
  description = "Runbook description"
}

variable "runbook_type" {
  description = "Runbook type"
}

variable "webhook_name" {
  description = "Webhook name"
}

variable "webhook_expiry_date" {
  description = "Webhook expiration date"
}

variable "to_email" {
  description = "Alert Receipient's email"
}

variable "from_email" {
  description = "Alert Sender's email"
}

variable "tags" {
  description = "(Required) Tags to be applied to the IP address to be created"
  type        = map(string)
  default     = {}
}