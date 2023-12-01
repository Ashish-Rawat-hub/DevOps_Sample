
variable "api_management_name" {
  description = "API Management name"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location for Eventhub."
  type        = string
}

variable "tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  type        = string
  description = "String consisting of two parts separated by an underscore. The fist part is the name, valid values include: Developer, Basic, Standard and Premium. The second part is the capacity"
  default     = "Developer_1"
}

variable "publisher_name" {
  type        = string
  description = "The name of publisher/company."
  default     = "FDBVB"
}

variable "publisher_email" {
  type        = string
  description = "The email of publisher/company."
  default     = "DLFDBVelaBridgedevtestMonitoring@fdbvela.com"
}

### NETWORKING

variable "virtual_network_type" {
  type        = string
  description = "The type of virtual network you want to use, valid values include: None, External, Internal."
  default     = null
}

variable "virtual_network_configuration" {
  type        = list(string)
  description = "The id(s) of the subnet(s) that will be used for the API Management. Required when virtual_network_type is External or Internal"
  default     = []
}

variable "min_api_version" {
  description = "The version which the control plane API calls to API Management service are limited with version equal to or newer than."
}

variable "user_id" {
  description = "(Optional) The ID of the User which should be assigned to this Subscription. Changing this forces a new resource to be created."
  default = null
}

variable "product_id" {
  description = "(Optional) The ID of the Product which should be assigned to this Subscription. Changing this forces a new resource to be created"
  default = null
}

variable "api_id" {
  description = "(Optional) The ID of the API which should be assigned to this Subscription. Changing this forces a new resource to be created"
  default = null
}

variable "display_name" {
  description = "(Required) The display name of this Subscription"
}

variable "allow_tracing" {
  description = "(Optional) Determines whether tracing can be enabled"
  default = false
}

variable "state" {
  description = "(Optional) The state of this Subscription. Possible values are active, cancelled, expired, rejected, submitted and suspended"
  default = "active"
}

variable "key_vault_id" {
  type = any
  description = "Key Vault ID"
  default     = null
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  default     = ""
}