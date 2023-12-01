variable "create" {
  description = "Control whether to create resource group"
  type = bool
  default = false
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "resource_group_location" {
  description = "Resource group location"
}

variable "tags" {
  description = "Resource group tags"
}

