variable "key_vault_id" {
  type = any
  description = "Key Vault ID"
  default     = null
}

variable "admin_objects_ids" {
  description = "Ids of the objects that can do all operations on all keys, secrets and certificates"
  type = list(string)
  default = []
}

variable "reader_objects_ids" {
  description = "Ids of the objects that can read all keys, secrets and certificates"
  type = list(string)
  default = []
}

variable "key_vault_secrets" {
  type        = list(any)
  default     = []
}

variable "secret_expiration_date" {
  description = "Expiration date for key vault secrets"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "master_secret_name" {
  description = "Secret names to be fetched from the Master key vault"
  default = []
}

variable "master_key_vault_id" {
  description = "master key vault id"
  type        = string
  default = ""
}