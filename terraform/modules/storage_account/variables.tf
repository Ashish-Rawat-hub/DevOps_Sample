variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "location" {
  description = "(Optional) The location in which the resources will be created."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the azure storage account"
  default     = ""
}

variable "account_kind" {
  description = "The type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  default     = "StorageV2"
}

variable "account_tier" {
  description = "The type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The type of storage account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2."
  default     = "LRS"
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  default     = "TLS1_2"
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD)."
  type        = bool
  default     = true
}

variable "network_rules" {
  description = "Object with attributes: `bypass`, `default_action`, `ip_rules`, `virtual_network_subnet_ids`. See https://www.terraform.io/docs/providers/azurerm/r/key_vault.html#bypass for more informations."
  default     = null

  type = object({
    bypass                     = list(string),
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })
}

variable "virtual_network_subnet_ids" {
  description = "virtual network subnet ids"
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


variable "private_endpoints_config" {
  description = "A map of private endpoints config to add to storage accounts"
  type        = map(object({
    is_manual_connection = bool
    subresource_names    = list(string)
    dnszonegroup_name    = string
  }))
  default     = {}
}

variable "private_endpoint_subnet_id" {
  description = "Subnet id of storage account private endpoint"
  default = ""
}

variable "private_dns_zone_name" {
  description = "Private DNS Zone name for private endpoint"
  default = ""
}

variable "virtual_network_private_link_name" {
  description = "Virtual Network Private link name"
  default = ""
}

variable "virtual_network_id" {
  description = "Virtual network id"
  default = ""
}

variable "create_private_endpoint" {
  type = bool
  default = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items within this Account to opt into being public."
  type = bool
  default = false
}