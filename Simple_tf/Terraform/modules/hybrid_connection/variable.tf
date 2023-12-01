variable "webapp_id" {
  description = "Web app id to connect the hybrid connection"
}

variable "webapp_name" {
  description = "Web app name to connect the hybrid connection"
}

variable "hybrid_connection_hostname" {
  description = "Hybrid connection name"
}

variable "hybrid_connection_port" {
  description = "Hybrid connection port"
}

variable "location" {
  description = "Resource group location"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "relay_name" {
  description = "Relay Name"
}

variable "relay_sku" {
  description = "Relay SKU"
}

variable "hybrid_connection_name" {
  description = "Relay Hybrid connect name"
}

variable "user_metadata" {
  description = "User metadata for relay hybrid connection"
  default = ""
}

variable "tags" {
  description = "tags"
}