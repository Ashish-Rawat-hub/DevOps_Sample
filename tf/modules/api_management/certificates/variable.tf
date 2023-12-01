variable "create_apim_certificate" {
  description = "Bool to choose whether to create api management certificate or not"
  default     = false
}

variable "apim_certificate_name" {
  description = "API Management certificate name"
  default = ""
}

variable "api_management_name" {
  description = "API Mananagement Name"
  default = ""
}

variable "resource_group_name" {
  description = "Resource Group Name"
  default = ""
}

variable "key_vault_id" {
  description = "Key vault id where the certificate is stored"
  default = ""
}

variable "api_management_id" {
  description = "API Management ID"
  default = ""
}