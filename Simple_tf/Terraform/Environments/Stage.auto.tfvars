service_principal_id   = "0a251d93-feb7-43a2-8632-59f13002d275"
infra = {
  "{{env}}" = {

    ###Resource Group
    create_resource_group   = true
    resource_group_location = "East US 2"
    resource_group_name     = "{{prefix}}-{{env}}-resource-group"

    ###Vnet Integration
    create_vnet_swift_conn   = true
    subnet_name              = "subnet-10.26.55.192_28-FDB-BusSys-WebApp-NonProd"
    vnet_name                = "vnet-10.26.55.128_25-eastus2"
    vnet_resource_group_name = "rg-20060000-CoreEUS2-NonProd"

    ###Service Plan
    asp_name         = "{{prefix}}-{{env}}-service-plan"
    service_plan_sku = "B1"
    os_type          = "Windows"

    ###Log Analytics Workspace
    app_insights_workspace_name = "{{prefix}}-{{env}}-log-analytics"
    log_analytics_workspace_sku = "PerGB2018"
    retention_in_days           = 30

    ###Web App API
    current_stack_api  = "dotnet"
    dotnet_version_api = "v7.0"
    webapp_name_api    = "{{prefix}}-{{env}}-webapp-api"
    webapp_cors_api    = ["https://{{prefix}}-{{env}}-webapp-ui.azurewebsites.net"]

    ###Web App UI
    current_stack_ui  = "dotnet"
    dotnet_version_ui = "v7.0"
    webapp_name_ui    = "{{prefix}}-{{env}}-webapp-ui"
    ip_restriction    = [
    {
      name                      = "Vnet_Access_Only"
      priority                  = 300
      virtual_network_subnet_id = "/subscriptions/97d730d5-b1c9-4457-8887-694c44c7b10a/resourceGroups/rg-20060000-CoreEUS2-NonProd/providers/Microsoft.Network/virtualNetworks/vnet-10.26.55.128_25-eastus2/subnets/subnet-10.26.55.192_28-FDB-BusSys-WebApp-NonProd" #Add subnet id here from which access should be granted
      ip_address                = null
      action                    = "Allow"
    },
    {
      name                      = "FDB 1"
      priority                  = 301
      virtual_network_subnet_id = null
      ip_address                = "10.125.8.192/26"
      action                    = "Allow"
    },
    {
      name                      = "FDB 2"
      priority                  = 302
      virtual_network_subnet_id = null
      ip_address                = "10.26.2.64/26"
      action                    = "Allow"
    },
    {
      name                      = "FDB 3"
      priority                  = 303
      virtual_network_subnet_id = null
      ip_address                = "10.245.8.192/26"
      action                    = "Allow"
    },
    {
      name                      = "FDB 4"
      priority                  = 304
      virtual_network_subnet_id = null
      ip_address                = "10.48.2.64/26"
      action                    = "Allow"
    },
    {
      name                      = "FDB 5"
      priority                  = 305
      virtual_network_subnet_id = null
      ip_address                = "20.185.107.192"
      action                    = "Allow"
    },
    {
      name                      = "FDB 6"
      priority                  = 306
      virtual_network_subnet_id = null
      ip_address                = "20.185.106.40"
      action                    = "Allow"
    },
    {
      name                      = "FDB 7"
      priority                  = 307
      virtual_network_subnet_id = null
      ip_address                = "20.189.134.178"
      action                    = "Allow"
    },
    {
      name                      = "FDB 8"
      priority                  = 308
      virtual_network_subnet_id = null
      ip_address                = "20.189.133.176"
      action                    = "Allow"
    },
    {
      name                      = "FDB 9"
      priority                  = 309
      virtual_network_subnet_id = null
      ip_address                = "20.36.246.203"
      action                    = "Allow"
    },
    {
      name                      = "FDB 10"
      priority                  = 310
      virtual_network_subnet_id = null
      ip_address                = "40.67.159.59"
      action                    = "Allow"
    },
    {
      name                      = "FDB 11"
      priority                  = 311
      virtual_network_subnet_id = null
      ip_address                = "40.67.191.74"
      action                    = "Allow"
    },
    {
      name                      = "FDB 12"
      priority                  = 312
      virtual_network_subnet_id = null
      ip_address                = "40.67.186.98"
      action                    = "Allow"
    },
    {
      name                      = "FDB 13"
      priority                  = 313
      virtual_network_subnet_id = null
      ip_address                = "40.90.219.193"
      action                    = "Allow"
    },
    {
      name                      = "FDB 14"
      priority                  = 314
      virtual_network_subnet_id = null
      ip_address                = "40.90.218.107"
      action                    = "Allow"
    },
    {
      name                      = "Deny_All_IPs"
      priority                  = 10000
      virtual_network_subnet_id = null
      ip_address                = "0.0.0.0/0"
      action                    = "Deny"
    }    
    ]

    ###App Insights UI
    app_insights_name_ui = "{{prefix}}-{{env}}-app-insights-ui"
    app_type_ui          = "web"

    ###App Insghts API
    app_insights_name_api = "{{prefix}}-{{env}}-app-insights-api"
    app_type_api          = "web"

    ###Key Vault
    keyvault_name         = "{{prefix}}-{{env}}-kv"
    keyvault_sku          = "standard"
    DefaultConnection     = "{{DefaultConnection}}"

    ## #App Configuration
    app_configuration_name = "{{prefix}}-{{env}}-app-configuration"
    app_config_key         =  [
      {
        key                = "AzureAd:ClientId"
        type               = "kv"
        value              = "{{AzureAdClientId}}"
        label              = ""
      },
      {
        key                = "AzureAd:Domain"
        type               = "kv"
        value              = "msidentitysamplestesting.onmicrosoft.com"
        label              = ""
      },
      {
        key                = "AzureAd:Instance"
        type               = "kv"
        value              = "https://login.microsoftonline.com/"
        label              = ""
      },
      {
        key                = "AzureAd:TenantId"
        type               = "kv"
        value              = "{{AzureAdTenantId}}"
        label              = ""
      },
      {
        key                = "CacheTimeInSeconds"
        type               = "kv"
        value              = "3600"
        label              = ""
      },
      {
        key                = "Sentinel"
        type               = "kv"
        value              = "1"
        label              = ""
      },
      {
        key                = "FtpServer"
        type               = "kv"
        value              = "{{FtpServer}}"
        label              = ""
      }
    ]
  }
}