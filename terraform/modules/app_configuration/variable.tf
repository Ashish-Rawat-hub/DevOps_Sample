variable "app_configuration_name" {
  description = "App configuration name"
}

variable "resource_group_name" {
  description = "App configuration's resource group name"
}

variable "location" {
  description = "App configuration's resource group location"
}

variable "tags" {
  description = "tags"
}

variable "app_config_key" {
  type = list(object({
    key                 = string
    type                = string
    label               = optional(string)
    value               = optional(string)
    vault_key_reference = optional(string)
  }))
}  

variable "sp_object_id" {
  description = "Service Principal Object ID"
}