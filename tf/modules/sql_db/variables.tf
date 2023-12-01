# variable "resource_group_name" {
#   description = "The name of the resource group of the SQL DB"
#   type        = string
# }

# variable "location" {
#   description = "The location of the SQL DB"
#   type        = string
# }

variable "name" {
  description = "The name of the SQL DB"
  type        = string
}

variable "server_id" {
  description = "The ID of the SQL DB Server"
  type        = string
}

variable "sku_name" {
  description = "SqlDB Sku Name"
  type        = string
}

variable "tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}
