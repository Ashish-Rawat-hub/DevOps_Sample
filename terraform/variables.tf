############################################
### Common Variables
############################################
variable "environment" {
  description = "Project environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Azure region to use"
  type        = string
  default     = "{{location}}"
}

variable "tags" {
  description = "Custom tags to add"
  type        = map(string)
  default     = {}
}

variable "service_principal_id" {
  description = "Service Principal Id"
  type        = string
}

variable "azurerm_access" {
  type        = list(any)
  description = "Azure rbac access"
  default     = []
}



############################################
## Infrastructure
############################################
variable "infra" {
  description = "MPH infrastructure configuration map"
  type = map(object({
    ############################################
    ## Resource Group Details
    ############################################
    create_resource_group     = optional(bool)
    location                  = optional(string)
    resource_group_name       = optional(string)
    ############################################
    ## Container apps Details
    ############################################
    container_app_env_name    = optional(string)
    container_app_name_ui     = optional(string)
    container_app_name_api    = optional(string)
    container_app_ingress_ui  = optional(map(any))
    container_app_ingress_api = optional(map(any))
    container_name_ui         = optional(string)
    container_cpu_ui          = optional(string)
    container_memory_ui       = optional(string)
    container_env_ui          = optional(any)   
    container_app_registry_ui = optional(any)
    container_name_api        = optional(string)
    container_cpu_api         = optional(string)
    container_memory_api      = optional(string)
    container_env_api         = optional(any)   
    container_app_registry_api= optional(any)
    ############################################
    ## App Configuration
    ############################################
    app_configuration_name    = optional(string)
    app_config_key            = list(object({
      key                     = string
      type                    = string
      label                   = optional(string)
      value                   = optional(string)
      vault_key_reference     = optional(string)
    }))
    ############################################
    ## Storage Account
    ############################################
    storage_account_name      = optional(string)
    account_tier              = optional(string)
    account_replication_type  = optional(string)

    keyvault_name             = optional(string)
    keyvault_sku              = optional(string)

    application_insights_name = optional(string)
    log_analytics_workspace   = optional(string)
    sku                       = optional(string)
    ############################################
    ## Container Registry
    ############################################
    container_registry_name   = optional(string)
    container_registry_sku    = optional(string)
    admin_enabled             = optional(bool)
  }))
}


