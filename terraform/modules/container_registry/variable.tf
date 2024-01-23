variable "container_registry_name" {
  description = "Specifies the name of the Container Registry"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container Registry"
}

variable "resource_group_location" {
  description = "Specifies the supported Azure location where the resource exists"
}

variable "container_registry_sku" {
  description = "The SKU name of the container registry"
  default = "Standard"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled"
  default = false
}