variable "keyvault_name" {
  description = "Key vault name"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "location" {
  description = "Resource group location"
}

# variable "principal_display_name" {
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