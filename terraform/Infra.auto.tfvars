## azure region
region = "East US 2"

## stack environment
environment = "dev"

tags = {
 env          = "dev"
 app          = "mph"
}

service_principal_id = "8d183355-046e-408b-9836-04367bc083ab"

##########################################################
#### Infrastruture Configuration
##########################################################

infra = {
  "dev" = {
    ###############################################################
    ######## Resource Group Details
    ###############################################################
    create_resource_group       = "true"
    location                    =  "East US 2"
    resource_group_name         = "mph-dev-rg"
    
    container_app_env_name      = "mph-dev-container-app-env"
    container_app_name_ui       = "mph-dev-container-app-ui"
    container_name_ui           = "container-ui"
    container_cpu_ui            = "2"
    container_memory_ui         = "4Gi"
    container_env_ui            = {
      "ASPNETCORE_ENVIRONMENT"  = "Development"
    }
    container_app_ingress_ui    = {
        allow_insecure_connections = "true"
        external_enabled           = "true"
        target_port                = 8080
        transport                  = "auto"
        latest_revision            = "true"
        percentage                 = 100
      }
    container_app_ingress_api   = {}
    container_app_name_api      = "mph-dev-container-app-api"
    container_name_api          = "container-api"
    container_cpu_api           = "0.25"
    container_memory_api        = "0.5Gi"
    container_env_api           = {
      "ASPNETCORE_ENVIRONMENT"  = "Development"
    }
    
    app_configuration_name      = "mph-dev-app-config"
    app_config_key              = []
    
    storage_account_name        = "mphdevsa"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    keyvault_name               = "mph-dev-kv"
    keyvault_sku                = "standard"

    application_insights_name   = "mph-dev-app-insights"
    log_analytics_workspace     = "mph-dev-log-analytics"
    sku                         = "Standalone"

    container_registry_name     = "mphdevacr"
    container_registry_sku      = "Standard"
    admin_enabled               = false
  }
}