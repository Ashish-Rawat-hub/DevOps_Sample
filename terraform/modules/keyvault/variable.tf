variable "keyvault_name" {
  description = "Key vault name"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "location" {
  description = "Resource group location"
}

# variable "service_principal_id" {
#   description = "Service principal display name"
# }

variable "keyvault_sku" {
  description = "Key vault sku"
}

variable "tags" {
  description = "tags"
}

variable "tenant_id" {
  description = "Tenant Id"
}

variable "kv_secrets" {
  description = "Key vault secrets"
  type = map(string)
  default = {}
}

variable "enable_rbac_authorization" {
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions."
  type        = bool
  default     = false
}

variable "purge_protection_enabled" {
  description = "Is Purge Protection enabled for this Key Vault?"
  default = false
}