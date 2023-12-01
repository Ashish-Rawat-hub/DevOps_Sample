variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "api_management_name" {
  description = "API Management name"
  type        = string
}

variable "create_named_value" {
  type = bool
  default = false
  description = "Toggle to decide whether to create named value or not"
}

variable "function_app_name" {
  description = "Function app name for the named value"
}

variable "key_vault_id" {
  type = any
  description = "Key Vault ID"
}

variable "named_value_name" {
  description = "Name of the named value."
}

variable "kv_secret_expiration_date" {
  description = "Key vault secret expiration date"
}

variable "principal_display_name" {
  description = "Principal Display Name"
}

variable "resource_id" {
  description = "Resource id to be linked with backend"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "function_rg_name" {
  description = "Function app resource group if function app and API Management are in different resource group"
  default = ""
}

variable "apim_certificate_thumbprint" {
  description = "API Management Certificate Thumbprint"
  default = ""
}

variable "backend_name" {
  description = "API Management Backend Name"
}