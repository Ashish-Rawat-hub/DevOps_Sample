variable "principal_display_name" {
  description = "Principal Display Name"
  type        = string
  default     = ""
}

variable "service_principal_id" {
  description = "Service Principal Object id"
  type        = string
}

variable "infra" {
  type = map(object({
    create_resource_group   = optional(bool)
    resource_group_name     = optional(string)
    resource_group_location = optional(string)

    ###Vnet Integration
    create_vnet_swift_conn    = optional(bool)
    subnet_name               = optional(string)
    vnet_name                 = optional(string)
    vnet_resource_group_name  = optional(string)

    ##Service Plan
    service_plan_sku = optional(string)
    os_type          = optional(string)
    asp_name         = optional(string)

    ##App service UI
    webapp_name_ui    = optional(string)
    current_stack_ui  = optional(string)
    dotnet_version_ui = optional(string)
    ip_restriction    = optional(any)

    ##App service API  
    webapp_name_api    = optional(string)
    current_stack_api  = optional(string)
    dotnet_version_api = optional(string)
    webapp_cors_api    = optional(any)

    ###Static Web App
    static_app_name     = optional(string)
    static_app_location = optional(string)
    static_sku_tier     = optional(string) 
    static_sku_size     = optional(string)
    ApiBasePath         = string

    ##App Insights UI
    app_insights_name_ui = optional(string)
    app_type_ui          = optional(string)

    ##App Insights API
    app_insights_name_api = optional(string)
    app_type_api          = optional(string)

    ##Log Analytics Workspace
    app_insights_workspace_name = string
    log_analytics_workspace_sku = string
    retention_in_days           = string

    ##Key Vault
    keyvault_name           = string
    resource_group_name     = optional(string)
    resource_group_location = optional(string)
    DefaultConnection       = string
    #principal_display_name   = string
    keyvault_sku = string

    ##App Configuration
    app_configuration_name = string
    app_config_key         = list(object({
      key                  = string
      type                 = string
      label                = optional(string)
      value                = optional(string)
      vault_key_reference  = optional(string)
    }))

    ##Hybrid Connection
    hybrid_connection_hostname = optional(string)
    hybrid_connection_port     = optional(string)
    relay_name                 = optional(string)
    relay_sku                  = optional(string)
    hybrid_connection_name     = optional(string)
  }))
}