variable "create" {
  description = "Control toggle to control creation of resources"
  type        = string
  default     = false
}

variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = []
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)
  default     = {}
}

variable "vnet_location" {
  description = "The location of the vnet to create. Defaults to the location of the resource group."
  type        = string
}

variable "subnets" {
  description = "Subnets attached to the virtual network"
  type        = list(any)
  default     = []
}

variable "nsg_name" {
  description = "nsg name"
}

variable "nsg_rules" {
  description = "nsg rules"
  #type = any
  default     = []
}

variable "nsg_id" {
  description = "nsg id"
  default = ""
}