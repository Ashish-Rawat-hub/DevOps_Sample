############################################
### Common Variables
############################################
variable "environment" {
  description = "Project environment"
  type        = string
  default     = "{{env}}"
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

variable "principal_display_name" {
  description = "Principal Display Name"
  type        = string
}

variable "azurerm_access" {
  type        = list(any)
  description = "Azure rbac access"
  default     = []
}

############################################
## Resource Group
############################################
variable "resource_groups" {
  description = "Resource group configuration map"
  type = map(object({
    resource_group_name   = optional(string)
    create_resource_group = optional(bool)
    location              = optional(string)
  }))
  default = {}
}

#########################################
## Virutal Network
#########################################
variable "networks" {
  description = "Virtual network configuration map"
  type = map(object({
    create_resource_group = optional(bool)
    location              = optional(string)
    resource_group_name   = optional(string)
    vnet = optional(object({
      create_vnet   = optional(bool)
      vnet_name     = optional(string)
      address_space = optional(list(string))
      subnets       = optional(list(any))
      nsg_name      = optional(string)
      nsg_rules     = optional(any)
    }))
  }))
  default = {}
}

############################################
### Function App Object
############################################
variable "function_apps" {
  description = "Function App configuration map"
  type = map(object({
    create_resource_group             = optional(bool)
    resource_group_name               = optional(string)
    main_rg_name                      = optional(string)
    location                          = optional(string)

    data_source = optional(object({
      app_insight_name                 = optional(string)
      api_management_name              = optional(string)
      audit_log_analytics_name         = optional(string)
      audit_sa_name                    = optional(string)
    }))

    ## Storage account details
    storage_account = optional(object({
      storage_account_name              = optional(string)
      private_dns_zone_name             = optional(string)
      private_endpoints_config          = optional(map(object({
        is_manual_connection            = optional(bool)
        subresource_names               = optional(list(string))
        dnszonegroup_name               = optional(string)
      })))
      network_rules = optional(object({
        bypass                     = list(string)
        default_action             = string
        ip_rules                   = list(string)
        virtual_network_subnet_ids = list(string)
    }))
      pep_subnet_id                     = optional(string)
      virtual_network_private_link_name = optional(string)
      virtual_network_id                = optional(string)
    }))

    function_app = optional(object({
      function_app_name                 = optional(string)
      function_app_version              = optional(string)
      function_app_plan_name            = optional(string)
      function_app_plan_tier            = optional(string)
      function_app_plan_size            = optional(string)
      function_app_plan_capacity        = optional(number)
      function_app_plan_kind            = optional(string)
      function_app_environment_id       = optional(string)
      function_app_app_settings         = optional(map(any))

      ## Virtual Network Details
      ip_restriction                   = optional(list(any))
      create_vnet_integration          = optional(bool)
      create_private_endpoint          = optional(bool)
      vnet_integration_subnet_id       = optional(string)
      private_endpoint_subnet_id       = optional(string)
      private_endpoint_name            = optional(string)
      allow_virtual_network_subnet_id  = optional(string)
      allow_ip_addresses               = optional(list(any))
      virtual_network_private_link_name = optional(string)
      virtual_network_id               = optional(string)
      api_management_public_ip         = optional(string)
      key_vault_id                     = optional(string)
    }))

    be_keyvault = optional(object({
      secret_expiration_date            = optional(string)
    }))

    ###### Sql Server Details
    be_sqlserver_link = optional(object({    
      create_virtual_network_rule           = optional(bool)
      sql_virtual_network_rule_name         = optional(string)
      sql_virtual_network_rule_subnet_id    = optional(string)
      sql_server_name                       = optional(string)
    }))

    ###### API Management Named Value
    apim = optional(object({
      create_named_value                    = optional(bool)
      api_management_name                   = optional(string)
      named_value_name                      = optional(string)
      apim_certificate_thumbprint           = optional(string)
      key_vault_id                          = optional(string)
      api_management_id                     = optional(string)
      backend_name                          = optional(string)
      create_apim_certificate               = optional(bool)
      apim_certificate_name                 = optional(string)
      cert_subject                          = optional(string)
      cert_validity                         = optional(number)
      key_usage                             = optional(list(string))
      cert_issuer_name                      = optional(string)
      cert_key_export                       = optional(bool)
      cert_key_type                         = optional(string)
      cert_reuse_key                        = optional(bool)
      cert_key_size                         = optional(number)
      cert_content_type                     = optional(string)
    }))

    ##Diagnostic Settings
    diagnostic_setting = optional(object({    
      diagnostic_name             = optional(string)
      retention_days              = optional(string)
      log_analytics_workspace_id  = optional(list(string))
    }))
    mssql_db_name = optional(string)
  }))
  default = {}
}

############################################
### App Service Type Object
############################################
variable "app_services" {
  description = "App service configuration map"
  type = map(object({
    create_resource_group               = optional(bool)
    resource_group_name                 = optional(string)
    location                            = optional(string)

    app_service = optional(object({
      app_service_plan_name             = optional(string)
      app_service_environment_id        = optional(string)
      app_service_plan_os_type          = optional(string)
      app_service_plan_sku              = optional(string)
      app_service_name                  = optional(string)
      https_only                        = optional(bool)
      dotnet_version                    = optional(string)
      app_settings                      = optional(map(any))
      site_config                       = optional(any)
      identity                          = optional(map(any))
      create_vnet_swift_conn            = optional(bool)
      vnet_integration_subnet_id        = optional(string)
      create_private_endpoint           = optional(bool)
      pep_subnet_id                     = optional(string)
      pep_subresource_names             = optional(list(string))
      pep_manual_connection             = optional(bool)
      pep_pvt_dnsg                      = optional(map(string))
      key_vault_id                      = optional(string)
      ip_restriction                    = optional(list(any))
     }))

    ##Diagnostic Settings
    diagnostic = optional(object({
      fe_as_diag_name                   = optional(string)
      fe_kv_diag_name                   = optional(string)
      diag_retention_days               = optional(string)
      audit_log_analytics_id            = optional(list(string))
    }))

    ##Data Source
    ##Diagnostic Settings
    data_source = optional(object({
      app_insight_name                   = optional(string)
      main_rg_name                       = optional(string)
      diag_retention_days               = optional(string)
      audit_log_analytics_id            = optional(list(string))
    }))

    tags   = optional(map(any))

  }))
  default = {}
}

############################################
### Shared Infrastructure
############################################
variable "shared_infra" {
  description = "Function App configuration map"
  type = map(object({
    create_resource_group = optional(bool)
    resource_group_name   = optional(string)
    location              = optional(string)

    ## Disaster Recovery Resource Group
    create_dr_resource_group = optional(bool)
    dr_resource_group_name   = optional(string)
    dr_location              = optional(string)

    ## Virtual Network
    vnet = optional(object({
      create_vnet           = optional(bool)
      vnet_name     = optional(string)
      address_space = optional(list(string))
      subnets       = optional(list(any))
      nsg_name      = optional(string)
      nsg_rules     = optional(any)
    }))

    dr_vnet = optional(object({
      create_vnet     = optional(bool)
      vnet_name       = optional(string)
      address_space   = optional(list(string))
      subnets         = optional(list(any))
      nsg_name        = optional(string)
      nsg_rules       = optional(any)
    }))

    ## App Insights
    log_analytics_workspace   = optional(string)
    application_insights_name = optional(string)

    ## Vela Network Key Vault
    fdb_vela_keyvault         = optional(string)

    ## Storage Account
    storage_account_name = optional(string)
    private_dns_zone_name             = optional(string)
    private_endpoints_config          = optional(map(object({
      subnet_id                       = optional(string)
      is_manual_connection            = optional(bool)
      subresource_names               = optional(list(string))
      dnszonegroup_name               = optional(string)
      private_dns_zone_ids            = optional(list(string))
    })))
    subnet_id                         = optional(string)
    virtual_network_private_link_name = optional(string)
    virtual_network_id                = optional(string)       
    sa_network_rules = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = list(string)
      virtual_network_subnet_ids = list(string)
    }))

    ######Key Vault
    keyvault = optional(object({
      create_key_vault                  = optional(bool)
      key_vault_name                    = optional(string)
      kv_create_private_endpoint        = optional(bool)
      principal_display_name            = optional(string)
      master_key_vault_id               = optional(string)
      master_secret_name                = optional(list(string))
      key_vault_secrets                 = optional(list(any))
      fetch_master_key_vault_secrets    = optional(bool)
      secret_expiration_date            = optional(string)
      create_private_endpoint           = optional(bool)
      private_endpoint_subnet_id        = optional(string)
      kv_enable_rbac_authorization      = optional(string)
      kv_logs_destinations_ids          = optional(any)
      admin_objects_ids                 = optional(list(string))
      reader_objects_ids                = optional(list(string))
      key_vault_alert_name              = optional(string)
      key_vault_action_group_name       = optional(string)
      key_vault_action_group_short_name = optional(string)
      key_vault_alert_description       = optional(string)
      purge_protection_enabled          = optional(bool)
      virtual_network_subnet_ids        = optional(list(string))
      kv_network_acls = optional(object({
        bypass                     = string
        default_action             = string
        ip_rules                   = list(string)
        virtual_network_subnet_ids = list(string)
      }))
      diag_settings_name                = optional(string)
      diag_retention_days               = optional(string)
      audit_log_analytics_id            = optional(list(string))
    }))

    ## Audit Storage Account
    shared_infra_audit_sa_name                 = optional(string)
    audit_snet                                 = optional(string)
    shared_infra_audit_sa_dns_zone             = optional(string)
    shared_infra_audit_sa_vnet_pep             = optional(string)
    audit_sa_network_rules = optional(object({
      bypass                     = optional(list(string))
      default_action             = optional(string)
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))
    shared_infra_audit_sa_pep_configs          = optional(map(object({
      is_manual_connection          = optional(bool)
      subresource_names             = optional(list(string))
      dnszonegroup_name             = optional(string)
    })))
    shared_infra_audit_sa_vnet                 = optional(string)

    ### SQL Server 
    sqlserver = optional(object({
      sqlserver                          = optional(list(any))
      create_sql_server                  = optional(bool)
      create_sql_database                = optional(bool)
      sql_server_name                    = optional(string)
      mssql_db_name                      = optional(string)
      version                            = optional(string)
      enable_aad_authentication_only     = optional(bool)
      administrator_login                = optional(string)
      administrator_login_pass           = optional(string)
      public_network_access_enabled      = optional(string)
      minimum_tls_version                = optional(string)
      mssql_databases                    = optional(list(any))
      sql_create_private_endpoint        = optional(bool)
      create_virtual_network_rule        = optional(bool)
      sql_create_vnet_swift_conn         = optional(bool)
      private_endpoint_subnet_id         = optional(string)
      sql_virtual_network_rule_name      = optional(string)
      sql_virtual_network_rule_subnet_id = optional(string)
      sql_virtual_network_endpoint_name  = optional(string)
      sql_server_alert_name              = optional(string)
      sql_server_action_group_name       = optional(string)
      sql_server_action_group_short_name = optional(string)
      sql_server_alert_description       = optional(string)
      storage_account_access_key_is_secondary = optional(bool)
      retention_in_days                  = optional(string)
      private_dns_zone_group_name        = optional(string)
      private_dns_zone_name              = optional(string)
      virtual_network_private_link_name = optional(string)
      sql_a_record_name                  = optional(string)
      enable_geo_replication             = optional(bool)
      dr_resource_group_name             = optional(string)
      location_secondary                 = optional(string)
      secondary_resource_group_name      = optional(string)
      secondary_sql_server_name          = optional(string)
      secondary_sql_db_name              = optional(string)      

      #vulnerability Assessment
      create_assessment                   = optional(bool)
      shared_infra_audit_sa_name          = optional(string)
      storage_container_name              = optional(string)
      storage_container_access_type       = optional(string)
      alert_policy_state                  = optional(string)
      recurring_scans_enabled             = optional(bool)
      recurring_email_subscription_admins = optional(bool)
      recurring_emails                    = optional(list(string))

      diag_settings_name                  = optional(string)
      diag_retention_days                 = optional(string)
      audit_log_analytics_id              = optional(list(string))
    }))

    ### SQL Server 
    dr_sqlserver = optional(object({
      sqlserver                          = optional(list(any))
      create_sql_server                  = optional(bool)
      create_sql_database                = optional(bool)
      sql_server_name                    = optional(string)
      mssql_db_name                      = optional(string)
      version                            = optional(string)
      enable_aad_authentication_only     = optional(bool)
      administrator_login                = optional(string)
      administrator_login_pass           = optional(string)
      public_network_access_enabled      = optional(string)
      minimum_tls_version                = optional(string)
      mssql_databases                    = optional(list(any))
      sql_create_private_endpoint        = optional(bool)
      create_virtual_network_rule        = optional(bool)
      sql_create_vnet_swift_conn         = optional(bool)
      private_endpoint_subnet_id         = optional(string)
      sql_virtual_network_rule_name      = optional(string)
      sql_virtual_network_rule_subnet_id = optional(string)
      sql_virtual_network_endpoint_name  = optional(string)
      sql_server_alert_name              = optional(string)
      sql_server_action_group_name       = optional(string)
      sql_server_action_group_short_name = optional(string)
      sql_server_alert_description       = optional(string)
      storage_account_access_key_is_secondary = optional(bool)
      retention_in_days                  = optional(string)
      private_dns_zone_group_name        = optional(string)
      private_dns_zone_name              = optional(string)
      virtual_network_private_link_name = optional(string)
      sql_a_record_name                  = optional(string)
      enable_geo_replication             = optional(bool)
      dr_resource_group_name             = optional(string)
      location_secondary                 = optional(string)
      secondary_resource_group_name      = optional(string)
      secondary_sql_server_name          = optional(string)
      secondary_sql_db_name              = optional(string)      

      #vulnerability Assessment
      create_assessment                   = optional(bool)
      shared_infra_audit_sa_name          = optional(string)
      storage_container_name              = optional(string)
      storage_container_access_type       = optional(string)
      alert_policy_state                  = optional(string)
      recurring_scans_enabled             = optional(bool)
      recurring_email_subscription_admins = optional(bool)
      recurring_emails                    = optional(list(string))      
    }))

    frontdoor = optional(object({
      ## Azure Front Door
      front_door_name                   = optional(string)
      front_door_sku_name               = optional(string)
      certificate_name_check            = optional(bool)
      load_balancer_enabled             = optional(bool)
      backend_timeout_seconds           = optional(any)
      frontdoor_loadbalancer            = optional(list(any))
      frontend_endpoint                 = optional(list(any))
      frontdoor_routing_rule            = optional(list(any))
      forwarding_configuration          = optional(list(any))
      redirect_configuration            = optional(list(any))
      frontdoor_health_probe            = optional(list(any))
      frontdoor_backend                 = optional(list(any))
      frontend_backend_host             = optional(string)
      frontdoor_firewall_policy_name    = optional(string)
      frontdoor_security_policy_name    = optional(string)
      backend                           = optional(list(any))

      ##Azure Monitoring Alerts
      create_action_group     = optional(bool)
      action_group_name       = optional(string)
      action_group_short_name = optional(string)
      runbook_receiver_name   = optional(string)

      ##Automation Account
      automation_acc_name = optional(string)
      automation_acc_sku  = optional(string)

      ##Runbook
      runbook_name        = optional(string)
      log_verbose         = optional(bool)
      log_progress        = optional(bool)
      runbook_description = optional(string)
      runbook_type        = optional(string)

      ##Webhook
      webhook_name        = optional(string)
      webhook_expiry_date = optional(string)
      to_email            = optional(string)
      from_email          = optional(string)
    }))

    ####### Api Management
    api_management = optional(object({
      api_management_name           = optional(string)
      sku_name                      = optional(string)
      virtual_network_type          = optional(string)
      virtual_network_configuration = optional(list(string))
      apim_create_vnet_swift_conn   = optional(bool)
      apim_create_private_endpoint  = optional(bool)
      min_api_version               = optional(string)
      display_name                  = optional(string)
      state                         = optional(string)
      api_id                        = optional(string)
      key_vault_id                  = optional(string)
    }))

    ####### Api Management Auth Server
    apim_auth_server = optional(object({
      name                          = optional(string)
      display_name                  = optional(string)
      auth_endpoint                 = optional(string)
      client_id                     = optional(string)
      client_secret                 = optional(string)
      client_authentication_method  = optional(list(string))
      bearer_token_sending_methods  = optional(list(string))
      default_scope                 = optional(string)
      grant_types                   = optional(list(string))
      authorization_methods         = optional(list(string))
    }))


  }))
  default = {}
}

############################################
### Key Vault Object
############################################
variable "keyvaults" {
  description = "Key Vault Map"
  type = map(object({
      create_resource_group             = optional(bool)
      location                          = optional(string)
      resource_group_name               = optional(string)
      create_key_vault                  = optional(bool)
      key_vault_name                    = optional(string)
      key_vault_secrets                 = optional(list(any))
      create_private_endpoint           = optional(bool)
      principal_display_name            = optional(string)
      master_key_vault_id               = optional(string)
      private_endpoint_subnet_id        = optional(string)
      enable_rbac_authorization         = optional(string)
      location                          = optional(string)
      logs_destinations_ids             = optional(any)
      admin_objects_ids                 = optional(list(string))
      reader_objects_ids                = optional(list(string))
      secret_expiration_date            = optional(string)
      master_secret_name                = optional(list(string))
      virtual_network_subnet_ids        = optional(list(string))
      network_acls = optional(object({
        bypass                          = optional(string)
        default_action                  = optional(string)
        ip_rules                        = optional(list(string))
        virtual_network_subnet_ids      = optional(list(string))
      }))
      diag_settings_name                = optional(string)
      diag_retention_days               = optional(string)
      audit_log_analytics_id            = optional(list(string))
    }))
  default = {}
}

#########################################
## Front Door
#########################################
variable "front_doors" {
  description = "Front Door Configuration Map"
  type = map(object({
    create_resource_group = optional(bool)
    location              = optional(string)
    resource_group_name   = optional(string)
    create_vnet           = optional(bool)
    ## Virtual Network
    vnet = optional(object({
      vnet_name     = optional(string)
      address_space = optional(list(string))
      subnets       = optional(list(any))
      nsg_name      = optional(string)
      nsg_rules     = optional(any)
    }))
    front_door_name                = optional(string)
    front_door_hostname            = optional(string)
    front_door_sku_name            = optional(string)
    certificate_name_check         = optional(bool)
    load_balancer_enabled          = optional(bool)
    backend_timeout_seconds        = optional(any)
    frontdoor_loadbalancer         = optional(list(any))
    frontend_endpoint              = optional(list(any))
    frontdoor_routing_rule         = optional(list(any))
    forwarding_configuration       = optional(list(any))
    redirect_configuration         = optional(list(any))
    frontdoor_health_probe         = optional(list(any))
    frontdoor_backend              = optional(list(any))
    frontdoor_firewall_policy_name = optional(string)
    frontdoor_security_policy_name = optional(string)
    backend                        = optional(list(any))
  }))
  default = {}
}


############################################
### SQL DB Type Object
############################################
variable "sqldbs" {
  description = "Sql server configuration map"
  type = map(object({
    create_resource_group = optional(bool)
    create_vnet           = optional(bool)
    resource_group_name   = optional(string)
    location              = optional(string)
    principal_display_name = optional(string)
    vnet = optional(object({
      vnet_name     = optional(string)
      address_space = optional(list(string))
      subnets       = optional(list(any))
      nsg_name      = optional(string)
      nsg_rules     = optional(any)
    }))
    ### SQL Server 
    create_sql_server                  = optional(bool)
    create_sql_database                = optional(bool)
    mssql_db_name                      = optional(string)
    sql_server_name                    = optional(string)
    version                            = optional(string)
    public_network_access_enabled      = optional(string)
    administrator_login                = optional(string)
    administrator_login_pass           = optional(string)
    minimum_tls_version                = optional(string)
    mssql_databases                    = optional(list(any))
    principal_display_name             = optional(string)
    sql_create_private_endpoint        = optional(bool)
    create_virtual_network_rule        = optional(bool)
    sql_create_vnet_swift_conn         = optional(bool)
    sql_virtual_network_endpoint_name  = optional(string)
    private_endpoint_subnet_id         = optional(string)
    sql_virtual_network_rule_name      = optional(string)
    sql_virtual_network_rule_subnet_id = optional(string)
    sql_server_alert_name              = optional(string)
    sql_server_action_group_name       = optional(string)
    sql_server_action_group_short_name = optional(string)
    
    ##Audit Logging
    storage_account_access_key_is_secondary = optional(bool)
    retention_in_days                  = optional(string)

    ##Vulnerability Assessment
    create_assessment                   = optional(bool)
    storage_container_name              = optional(string)
    storage_container_access_type       = optional(string)
    alert_policy_state                  = optional(string)
    recurring_scans_enabled             = optional(bool)
    recurring_email_subscription_admins = optional(bool)
    recurring_emails                    = optional(list(string))
  }))
  default = {}
}

############################################
####### Api Management
############################################
variable "api_managements" {
  description = "API Management Configuation Map"
  type = map(object({
    create_resource_group = optional(bool)
    resource_group_name   = optional(string)
    location              = optional(string)
    api_management_name   = optional(string)
    sku_name              = optional(string)
    api = optional(object({
      api_name         = optional(string)
      api_display_name = optional(string)
      api_revision     = optional(string)
      protocols        = optional(string)
    }))
    virtual_network_type          = optional(string)
    virtual_network_configuration = optional(list(string))
    apim_create_vnet_swift_conn   = optional(bool)
    apim_create_private_endpoint  = optional(bool)
    min_api_version               = optional(string)
  }))
  default = {}
}

variable "mssqldb" {
  description = "Sql Database configuration map"
  type = map(object({
      resource_group_name                 = optional(string)
      create_sql_db                       = optional(bool)
      sql_db_name                         = optional(string)
      sqlservername                       = optional(string)
      primary_sqldb_id                    = optional(string)
      sku_name                            = optional(string)
      collation                           = optional(string)
      read_scale                          = optional(bool)
      zone_redundant                      = optional(bool)
      license_type                        = optional(string)
      create_secondary_db                 = optional(bool)
      threat_detection_policy             = optional(list(string))

      ##Diagnostic Settings
      diagnostic_setting = optional(object({    
        diagnostic_name             = optional(string)
        retention_days              = optional(string)
        log_analytics_workspace_id  = optional(list(string))
      }))
    }))

    # dr_sqldb = optional(object({
    #   dr_resource_group_name              = optional(string)
    #   create_sql_db                       = optional(bool)
    #   sql_db_name                         = optional(string)
    #   sqlservername                       = optional(string)
    #   primary_sqldb_id                    = optional(string)
    #   sku_name                            = optional(string)
    #   collation                           = optional(string)
    #   read_scale                          = optional(bool)
    #   zone_redundant                      = optional(bool)
    #   license_type                        = optional(string)
    #   create_secondary_db                 = optional(bool)
    #   threat_detection_policy             = optional(list(string))
    # }))
  default = {}
}

############################################
####Automation Account
############################################
variable "automation_acc" {
  description = "Automation Account map"
  type = map(object({
    create_resource_group = bool
    automation_acc_name   = string
    automation_acc_sku    = string
    resource_group_name   = optional(string)
    location              = optional(string)

    ##Runbook
    runbook_name        = string
    log_verbose         = optional(bool)
    log_progress        = optional(bool)
    runbook_description = string
    runbook_type        = string

    ##Webhook
    webhook_name        = string
    webhook_expiry_date = string
    to_email            = string
    from_email          = string

    ##Azure Monitoring Alerts
    create_action_group     = optional(bool)
    action_group_name       = optional(string)
    action_group_short_name = optional(string)
    runbook_receiver_name   = optional(string)
  }))
  default = {}
}

variable "diagnostic" {
  description = "Diagnostic settings configuration map"
  type = map(object({
    create_resource_group             = optional(bool)
    resource_group_name               = optional(string)
    location                          = optional(string)
    storage_account_id                = optional(string)

    kv_diagnostic_name                = optional(string)
    retention_days                    = optional(string)
    sqlserver_diagnostic_name_master  = optional(string)
    sqlserver_diagnostic_name_db      = optional(string)
    mssql_db_name                     = optional(string)
    api_management_audit_name         = optional(string)
    primary_vnet_audit_name           = optional(string)
    availability_vnet_audit_name      = optional(string)
    #retention_days                    = optional(string)
    app_service_diagnostic_name       = optional(string)

    auditing_storage_account_name      = optional(string)
    #####Storage account private endpoint details
    private_dns_zone_name             = optional(string)
    private_endpoints_config          = optional(map(object({
      subnet_id                       = optional(string)
      is_manual_connection            = optional(bool)
      subresource_names               = optional(list(string))
      dnszonegroup_name               = optional(string)
      private_dns_zone_ids            = optional(list(string))
    })))
    subnet_id                         = optional(string)
    virtual_network_private_link_name = optional(string)
    virtual_network_id               = optional(string)    
    
    log_analytics_workspace            = optional(string)
    application_insights_name          = optional(string)
    diagnostic_setting_name            = optional(string)

    availability_test_logic_app_diagnostic_name   = optional(string)
    availability_alert_logic_app_diagnostic_name  = optional(string)
  }))
  default = {}
}


variable "logic_app" {
  description = "Logic App map"
type = map(object({

    ## Virtual Network
    vnet = optional(object({
      vnet_name     = optional(string)
      address_space = optional(list(string))
      subnets       = optional(list(any))
      nsg_name      = optional(string)
      nsg_rules     = optional(any)
    }))

    logic_app_create_resource_group            = optional(bool)
    create_vnet                                = optional(bool)
    logic_app_resource_group_name              = optional(string)
    logic_app_location                         = optional(string)
    logic_app_function_app_name                = optional(string)
    logic_app_function_app_version             = optional(string)
    logic_app_function_app_plan_name           = optional(string)
    logic_app_function_app_plan_tier            = optional(string)
    logic_app_function_app_plan_size            = optional(string)
    logic_app_function_app_plan_capacity        = optional(number)
    logic_app_function_app_plan_kind            = optional(string)
    logic_app_function_app_environment_id       = optional(string)
    logic_app_function_app_app_settings        = optional(map(any))
    logic_app_storage_account_name             = optional(string)
    logic_app_storage_account_tier             = optional(string)
    logic_app_storage_account_replication_type = optional(string)
    logic_app_subnet_id                        = optional(string)
    logic_app_function_app_vnet_integration_subnet_id       = optional(string)
    logic_app_storage_create_private_endpoint          = optional(bool)
    logic_app_function_app_private_endpoint_subnet_id       = optional(string)
    logic_app_private_endpoint_name            = optional(string)
    logic_app_function_app_create_vnet_swift_conn           = optional(bool)
    logic_app_allow_virtual_network_subnet_id  = optional(string)
    logic_app_apim_public_ip_addresses         = optional(list(string))
    logic_app_function_app_apim_public_ip_addresses   = optional(any)
    logic_app_function_app_ftps_state                 = optional(string)

    #####Storage account private endpoint details
    private_dns_zone_name             = optional(string)
    private_endpoints_config          = optional(map(object({
      subnet_id                       = optional(string)
      is_manual_connection            = optional(bool)
      subresource_names               = optional(list(string))
      dnszonegroup_name               = optional(string)
      private_dns_zone_ids            = optional(list(string))
    })))
    subnet_id                         = optional(string)
    virtual_network_private_link_name = optional(string)
    virtual_network_id               = optional(string)

    ##Availability App Insights
    logic_app_log_analytics_workspace          = optional(string)
    logic_app_application_insights_name        = optional(string)

    ##Availability Key vault
    availability_keyvault_resource_group_name  = optional(string)

    ##Availability Functions
    kv_availability_function_name              = optional(string)
    availability_function_language             = optional(string)
    sql_server_availability_function_name      = optional(string)

    ##Availability Alert Functions
    kv_availability_alert_function_name               = optional(string)
    sql_server_availability_alert_function_name       = optional(string)

    ##Logic App Availability
    availability_template_deployment_name             = optional(string) 
    availability_workflow_name                        = optional(string)
    frequency                                         = optional(string)
    interval                                          = optional(string)
    deployment_mode                                   = optional(string)
    env                                               = optional(string)
    logic_app_location                                = optional(string)
    keyvault_delay_frequency                          = optional(string)
    sqlserver_delay_frequency                         = optional(string)
    keyvault_delay_unit                               = optional(string)
    sqlserver_delay_unit                              = optional(string)

    ##Logic App Availability Alert
    alert_template_deployment_name                    = optional(string)                  
    alert_workflow_name                               = optional(string)

  }))
  default = {}
}