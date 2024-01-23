variable "create" {
  description = "Control toggle to control creation of resources"
  type        = bool
  default     = false
}

variable "rg_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Azure region to use"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}
