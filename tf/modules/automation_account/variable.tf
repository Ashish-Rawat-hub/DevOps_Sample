variable "automation_acc_name" {
  description = "Automation account name"
}

variable "location" {
  description = "Automation account location"
}

variable "resource_group_name" {
  description = "Automation account resource group name"
}

variable "automation_acc_sku" {
  description = "Automation account SKU"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}