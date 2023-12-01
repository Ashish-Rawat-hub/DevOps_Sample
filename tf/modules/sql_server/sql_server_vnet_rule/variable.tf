variable "create_virtual_network_rule" {
  description = "Control toggle to control creation of resources"
  type        = bool
  default     = false
}

variable "sql_virtual_network_rule_name" {
  description = "(Required) SQL virtual network rule subnet_id"
  default = ""
}

variable "resource_group_name" {
  description = "Name for the secondary resource group"
  default = ""
}

variable "sql_server_name" {
  description = "Sql Server Name"
  default = ""
}

variable "sql_virtual_network_rule_subnet_id" {
  description = "(Required) SQL virtual network rule subnet_id"
  default = ""
}