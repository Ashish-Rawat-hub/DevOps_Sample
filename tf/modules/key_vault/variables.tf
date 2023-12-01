variable "create_key_vault" {
  description = "Create Key Vault"
  type        = bool
}

variable "resource_group_name" {
  description = "Resource Group the resources will belong to"
  type        = string
}

variable "location" {
  description = "Azure location for Key Vault."
  type        = string
}

variable "master_key_vault_id" {
  description = "master key vault id"
  type        = string
}

variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are \"standard\" and \"premium\"."
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "secret_expiration_date" {
  description = "Expiration date for key vault secrets"
}

variable "virtual_network_subnet_ids" {
  description = "virtual network subnet ids"
  default     = []
}

# variable "enabled_for_disk_encryption" {
#   description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
#   type        = bool
#   default     = false
# }

# variable "enabled_for_template_deployment" {
#   description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault."
#   type        = bool
#   default     = false
# }

variable "admin_objects_ids" {
  description = "Ids of the objects that can do all operations on all keys, secrets and certificates"
  type        = list(string)
  default     = []
}

variable "reader_objects_ids" {
  description = "Ids of the objects that can read all keys, secrets and certificates"
  type        = list(string)
  default     = []
}

variable "network_acls" {
  description = "Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more informations."
  default     = null

  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })
}

# variable "enable_rbac_authorization" {
#   description = "Whether to enable rbac authorization"
#   type        = bool
#   default     = true
# }

variable "purge_protection_enabled" {
  description = "Whether to activate purge protection"
  type        = bool
  default     = false
}

/* variable "logs_destinations_ids" {
  type        = list(string)
  description = "List of destination resources Ids for logs diagnostics destination. Can be Storage Account, Log Analytics Workspace and Event Hub. No more than one of each can be set. Empty list to disable logging."
}

variable "logs_categories" {
  type        = list(string)
  description = "Log categories to send to destinations."
  default     = null
}

variable "logs_metrics_categories" {
  type        = list(string)
  description = "Metrics categories to send to destinations."
  default     = null
}

variable "logs_retention_days" {
  type        = number
  description = "Number of days to keep logs on storage account"
  default     = 30
} */

variable "create_private_endpoint" {
  default = false
  description = "toggle to control if the private endpoint is created"
  type = bool
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet Id for private end point"
  default     = null
}

variable "key_vault_secrets" {
  type        = list(any)
  default     = []
}

variable "fetch_master_key_vault_secrets" {
  type     = bool
  default  = false
}

variable "object_id" {
  description = "Azure Object ID"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}