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

variable "tenant_id" {
  description = "Azure Tenant ID"
}
