variable "name" {
  description = "(Required) Specifies the Name of the Private Endpoint. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the private Endpoint should be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "(Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created."
  type        = string
}

variable "private_service_connection" {
  description = "(Required) A private_service_connection block as defined below."
}

variable "private_dns_zone_group" {
  type = map(object({
    name                 = string
    private_dns_zone_ids = list(string)
  }))
  description = "Specifies Private DNS Zone Group"
}

variable "tags" {
  description = "(Required) Tags to be applied to the IP address to be created"
  type        = map(string)
  default     = {}
}