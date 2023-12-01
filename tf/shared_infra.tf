################################################################
## ## Azure Shared resource group
################################################################
module "shared_infra_rg" {
  source      = "./modules/resource_group"
  for_each    = var.shared_infra
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}

################################################################
## ## Azure Disaster Recovery resource group
################################################################
module "dr_rg" {
  source      = "./modules/resource_group"
  for_each    = var.shared_infra
  create      = each.value.create_dr_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.dr_location
  rg_name     = each.value.dr_resource_group_name
  tags        = merge(local.tags, var.tags)
}

################################################################
## ## Azure Shared Virtual Network
################################################################
module "shared_infra_vnet" {
  source              = "./modules/virtual_network"
  for_each            = var.shared_infra
  create              = each.value.vnet.create_vnet
  environment         = var.environment
  vnet_location       = each.value.location
  resource_group_name = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name
  vnet_name           = each.value.vnet.vnet_name
  address_space       = each.value.vnet.address_space
  subnets             = each.value.vnet.subnets
  nsg_name            = each.value.vnet.nsg_name
  nsg_rules           = each.value.vnet.nsg_rules == null ? {} : each.value.vnet.nsg_rules
  tags                = merge(local.tags, var.tags)
  depends_on          = [module.shared_infra_rg]
}

################################################################
## ## Azure Disaster Recovery Virtual Network
################################################################
module "dr_vnet" {
  source              = "./modules/virtual_network"
  for_each            = var.shared_infra
  create              = each.value.dr_vnet.create_vnet
  environment         = var.environment
  vnet_location       = each.value.dr_location
  resource_group_name = each.value.create_dr_resource_group == true ? module.dr_rg[each.key].resource_group_name : each.value.dr_resource_group_name
  vnet_name           = each.value.dr_vnet.vnet_name
  address_space       = each.value.dr_vnet.address_space
  subnets             = each.value.dr_vnet.subnets
  nsg_name            = each.value.dr_vnet.nsg_name
  nsg_rules           = each.value.dr_vnet.nsg_rules == null ? {} : each.value.dr_vnet.nsg_rules
  tags                = merge(local.tags, var.tags)
  depends_on          = [module.dr_rg]
}

################################################################
## ## Azure Shared App Insights 
################################################################
module "shared_infra_insights" {
  source                    = "./modules/app_insights"
  for_each                  = var.shared_infra
  location                  = each.value.location
  resource_group_name       = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name
  log_analytics_workspace   = each.value.log_analytics_workspace
  application_insights_name = each.value.application_insights_name
  tags                      = merge(local.tags, var.tags)
}

################################################################
## ## Azure Shared Audit Storage Account
################################################################
# module "shared_infra_audit_sa" {
#   source                            = "./modules/storage_account"
#   for_each                          = var.shared_infra
#   location                          = each.value.location
#   storage_account_name              = lower("${each.value.shared_infra_audit_sa_name}${random_string.unique.result}")
#   resource_group_name               = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name
#   private_endpoints_config          = each.value.shared_infra_audit_sa_pep_configs == null ? {} : each.value.shared_infra_audit_sa_pep_configs
#   private_endpoint_subnet_id        = each.value.audit_snet == null ? module.shared_infra_vnet[each.key].vnet_subnets["{{prefix}}-{{env}}-shared-sa-snet-{{postfix}}"].id : each.value.audit_snet
#   private_dns_zone_name             = each.value.shared_infra_audit_sa_dns_zone == null ? "${each.value.shared_infra_audit_sa_name}-privatelink.blob.core.windows.net" : each.value.shared_infra_audit_sa_dns_zone
#   virtual_network_private_link_name = each.value.shared_infra_audit_sa_vnet_pep
#   virtual_network_id                = each.value.shared_infra_audit_sa_vnet == null ? module.shared_infra_vnet[each.key].vnet_id : each.value.shared_infra_audit_sa_vnet
#   network_rules                     = each.value.audit_sa_network_rules
#   tags                              = merge(local.tags, var.tags)
# }

################################################################
## ## Azure Main SQL Server
################################################################
module "shared_infra_sql" {
  source                             = "./modules/sql_server"
  for_each                           = var.shared_infra
  resource_group_name                = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name
  location                           = each.value.location
  ## SQL Server Configs
  create_sql_server                  = each.value.sqlserver.create_sql_server
  mssql_server_name                  = each.value.sqlserver.sql_server_name

  ## SQL AD
  enable_aad_authentication_only     = each.value.sqlserver.enable_aad_authentication_only
  principal_display_name             = var.principal_display_name

  ## SQL Server Networking
  public_network_access_enabled      = each.value.sqlserver.public_network_access_enabled
  create_private_endpoint            = each.value.sqlserver.sql_create_private_endpoint
  create_virtual_network_rule        = each.value.sqlserver.create_virtual_network_rule
  sql_virtual_network_endpoint_name  = each.value.sqlserver.sql_virtual_network_endpoint_name
  private_endpoint_subnet_id         = each.value.sqlserver.private_endpoint_subnet_id == "" ? module.shared_infra_vnet[each.key].vnet_subnets["{{prefix}}-{{env}}-shared-sa-snet-{{postfix}}"].id : each.value.sqlserver.private_endpoint_subnet_id
  sql_virtual_network_rule_name      = each.value.sqlserver.sql_virtual_network_rule_name
  sql_virtual_network_rule_subnet_id = each.value.sqlserver.sql_virtual_network_rule_subnet_id == "" ? module.shared_infra_vnet[each.key].vnet_subnets["{{prefix}}-{{env}}-shared-func-snet-{{postfix}}"].id : each.value.sqlserver.sql_virtual_network_rule_subnet_id
  virtual_network_id                 = module.shared_infra_vnet[each.key].vnet_id
  private_dns_zone_group_name        = each.value.sqlserver.private_dns_zone_group_name
  private_dns_zone_name              = each.value.sqlserver.private_dns_zone_name
  virtual_network_private_link_name = each.value.sqlserver.virtual_network_private_link_name
  sql_a_record_name                  = each.value.sqlserver.sql_a_record_name

  ## Audit log
  # storage_endpoint                   = module.shared_infra_audit_sa[each.key].primary_blob_endpoint
  # storage_account_access_key         = module.shared_infra_audit_sa[each.key].storage_primary_access_key
  # storage_account_access_key_is_secondary = each.value.sqlserver.storage_account_access_key_is_secondary == null ? false : each.value.sqlserver.storage_account_access_key_is_secondary
  # retention_in_days                  = each.value.sqlserver.retention_in_days

  ## Vulneralibility Assessment
  create_assessment                  = each.value.sqlserver.create_assessment == null ? false : each.value.sqlserver.create_assessment 
  storage_account_name               = each.value.sqlserver.create_assessment == false ? null : lower("${each.value.sqlserver.shared_infra_audit_sa_name}${random_string.unique.result}")
  storage_container_name             = each.value.sqlserver.storage_container_name
  storage_container_access_type      = each.value.sqlserver.storage_container_access_type
  alert_policy_state                 = each.value.sqlserver.alert_policy_state
  recurring_scans_enabled            = each.value.sqlserver.recurring_scans_enabled
  recurring_email_subscription_admins= each.value.sqlserver.recurring_email_subscription_admins
  recurring_emails                   = each.value.sqlserver.recurring_emails
  tags                               = merge(local.tags, var.tags)
  depends_on                         = [module.shared_infra_rg, module.shared_infra_vnet]
}

################################################################
## ## Azure Disaster Recovery SQL Server
################################################################
module "dr_sql" {
  source                             = "./modules/sql_server"
  for_each                           = var.shared_infra
  resource_group_name                = each.value.create_dr_resource_group == true ? module.dr_rg[each.key].resource_group_name : each.value.dr_resource_group_name
  location                           = each.value.dr_location
  ## SQL Server Configs
  create_sql_server                  = each.value.dr_sqlserver.create_sql_server
  mssql_server_name                  = each.value.dr_sqlserver.sql_server_name
  #administrator_login                = each.value.sqlserver.administrator_login
  #administrator_login_pass           = random_password.password.result

  ## SQL AD
  enable_aad_authentication_only     = each.value.dr_sqlserver.enable_aad_authentication_only
  principal_display_name             = var.principal_display_name

  ## SQL Server Networking
  public_network_access_enabled      = each.value.dr_sqlserver.public_network_access_enabled
  create_private_endpoint            = each.value.dr_sqlserver.sql_create_private_endpoint
  create_virtual_network_rule        = each.value.dr_sqlserver.create_virtual_network_rule
  sql_virtual_network_endpoint_name  = each.value.dr_sqlserver.sql_virtual_network_endpoint_name
  private_endpoint_subnet_id         = each.value.dr_sqlserver.private_endpoint_subnet_id == "" ? module.dr_vnet[each.key].vnet_subnets["{{prefix}}-{{env}}-shared-sa-snet-{{secondary_postfix}}"].id : each.value.dr_sqlserver.private_endpoint_subnet_id
  sql_virtual_network_rule_name      = each.value.dr_sqlserver.sql_virtual_network_rule_name
  sql_virtual_network_rule_subnet_id = each.value.dr_sqlserver.sql_virtual_network_rule_subnet_id == "" ? module.dr_vnet[each.key].vnet_subnets["{{prefix}}-{{env}}-shared-func-snet-{{secondary_postfix}}"].id : each.value.dr_sqlserver.sql_virtual_network_rule_subnet_id
  virtual_network_id                 = module.dr_vnet[each.key].vnet_id
  private_dns_zone_group_name        = each.value.dr_sqlserver.private_dns_zone_group_name
  private_dns_zone_name              = each.value.dr_sqlserver.private_dns_zone_name
  virtual_network_private_link_name = each.value.dr_sqlserver.virtual_network_private_link_name
  sql_a_record_name                  = each.value.dr_sqlserver.sql_a_record_name

  ## Audit log
  #storage_endpoint                   = module.shared_infra_audit_sa[each.key].primary_blob_endpoint
  #storage_account_access_key         = module.shared_infra_audit_sa[each.key].storage_primary_access_key
  #storage_account_access_key_is_secondary = each.value.dr_sqlserver.storage_account_access_key_is_secondary == null ? false : each.value.dr_sqlserver.storage_account_access_key_is_secondary
  #retention_in_days                  = each.value.dr_sqlserver.retention_in_days

  ## Vulneralibility Assessment
  create_assessment                  = each.value.dr_sqlserver.create_assessment == null ? false : each.value.dr_sqlserver.create_assessment
  storage_account_name               = each.value.dr_sqlserver.create_assessment == false ? null : each.value.dr_sqlserver.shared_infra_audit_sa_name
  storage_container_name             = each.value.dr_sqlserver.storage_container_name
  storage_container_access_type      = each.value.dr_sqlserver.storage_container_access_type
  alert_policy_state                 = each.value.dr_sqlserver.alert_policy_state
  recurring_scans_enabled            = each.value.dr_sqlserver.recurring_scans_enabled
  recurring_email_subscription_admins= each.value.dr_sqlserver.recurring_email_subscription_admins
  recurring_emails                   = each.value.dr_sqlserver.recurring_emails
  tags                               = merge(local.tags, var.tags)
  depends_on                         = [module.dr_rg, module.dr_vnet]
}

################################################################
## Azure Shared Front Door
################################################################
# module "shared_infra_front_door" {
#   source                         = "./modules/front_door"
#   for_each                       = var.shared_infra
#   resource_group_name            = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name
#   front_door_name                = each.value.frontdoor.front_door_name
#   front_door_sku_name            = each.value.frontdoor.front_door_sku_name
#   front_door_load_balancing      = each.value.frontdoor.frontdoor_loadbalancer
#   frontend_backend_host          = each.value.frontdoor.frontend_backend_host
#   front_door_health_probe        = each.value.frontdoor.frontdoor_health_probe
#   frontdoor_firewall_policy_name = each.value.frontdoor.frontdoor_firewall_policy_name
#   frontdoor_security_policy_name = each.value.frontdoor.frontdoor_security_policy_name
#   tags                           = merge(local.tags, var.tags)
#   depends_on                     = [module.shared_infra_rg]
# }

################################################################
## Azure Shared API Management
################################################################
module "shared_infra_apim" {
  source                        = "./modules/api_management"
  for_each                      = var.shared_infra
  resource_group_name           = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name
  location                      = each.value.location
  api_management_name           = each.value.api_management.api_management_name
  virtual_network_type          = each.value.api_management.virtual_network_type
  sku_name                      = each.value.api_management.sku_name
  virtual_network_configuration = each.value.api_management.virtual_network_configuration
  min_api_version               = each.value.api_management.min_api_version
  display_name                  = each.value.api_management.display_name
  state                         = each.value.api_management.state
  api_id                        = each.value.api_management.api_id
  key_vault_id                  = each.value.api_management.key_vault_id == null ? module.shared_keyvault[each.key].key_vault_id : each.value.api_management.key_vault_id
  tenant_id                     = local.tenant_id
  tags                          = merge(local.tags, var.tags)
  depends_on                    = [module.shared_infra_rg]
}

module "apim_auth_server" {
  source                                  = "./modules/api_management/auth_server"
  for_each                                = var.shared_infra
  api_management_name                     = each.value.api_management.api_management_name
  resource_group_name                     = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name   
  name                                    = each.value.apim_auth_server.name
  display_name                            = each.value.apim_auth_server.display_name
  auth_endpoint                           = each.value.apim_auth_server.auth_endpoint
  client_id                               = each.value.apim_auth_server.client_id == null ? module.shared_keyvault_secrets["{{env}}"].key_vault_secrets["OktaClientId"].value : each.value.apim_auth_server.client_id
  client_secret                           = each.value.apim_auth_server.client_secret == null ? module.shared_keyvault_secrets["{{env}}"].key_vault_secrets["OktaClientSecret"].value : each.value.apim_auth_server.client_secret
  client_authentication_method            = each.value.apim_auth_server.client_authentication_method
  bearer_token_sending_methods            = each.value.apim_auth_server.bearer_token_sending_methods
  default_scope                           = each.value.apim_auth_server.default_scope
  grant_types                             = each.value.apim_auth_server.grant_types
  authorization_methods                   = each.value.apim_auth_server.authorization_methods
}

################################################################
## Azure Shared key Vault Management
################################################################
module "shared_keyvault" {
  source                     = "./modules/key_vault"
  for_each                   = var.shared_infra
  resource_group_name        = each.value.create_resource_group == true ? module.shared_infra_rg[each.key].resource_group_name : each.value.resource_group_name   
  location                   = each.value.location
  create_key_vault           = each.value.keyvault.create_key_vault
  name                       = "${each.value.keyvault.key_vault_name}${random_string.unique.result}"
  create_private_endpoint    = each.value.keyvault.create_private_endpoint == null ? false : each.value.keyvault.create_private_endpoint
  private_endpoint_subnet_id = each.value.keyvault.private_endpoint_subnet_id
  master_key_vault_id        = each.value.keyvault.master_key_vault_id == null ? "" : each.value.keyvault.master_key_vault_id
  key_vault_secrets          = []
  secret_expiration_date     = each.value.keyvault.secret_expiration_date == null ? null : each.value.keyvault.secret_expiration_date
  network_acls               = each.value.keyvault.kv_network_acls
  virtual_network_subnet_ids = each.value.keyvault.virtual_network_subnet_ids
  purge_protection_enabled   = each.value.keyvault.purge_protection_enabled  
  object_id                  = local.object_id
  tenant_id                  = local.tenant_id
  tags                       = merge(local.tags, var.tags)

  depends_on = [ module.shared_infra_vnet ]
}

module "shared_keyvault_secrets" {
  source                     = "./modules/key_vault/key_vault_secrets"
  for_each                   = var.shared_infra
  master_key_vault_id        = each.value.keyvault.master_key_vault_id == null ? "" : each.value.keyvault.master_key_vault_id
  key_vault_secrets          = [{
        name             = "OcpApimKeyFE"
        value            = module.shared_infra_apim["{{env}}"].apim_subscription_key
    }]
  secret_expiration_date     = each.value.keyvault.secret_expiration_date == null ? null : each.value.keyvault.secret_expiration_date
  key_vault_id               = module.shared_keyvault[each.key].key_vault_id
  admin_objects_ids          = each.value.keyvault.admin_objects_ids == null ? [] : each.value.keyvault.admin_objects_ids
  tenant_id                  = local.tenant_id
  reader_objects_ids         = each.value.keyvault.reader_objects_ids
  master_secret_name         = each.value.keyvault.master_secret_name == null ? [] : each.value.keyvault.master_secret_name
  depends_on                 = [module.shared_keyvault]
}

module "shared_keyvault_diagnostic" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.shared_infra
  name                       = each.value.keyvault.diag_settings_name
  resource_id                = module.shared_keyvault[each.key].key_vault_id
  logs_destinations_ids      = each.value.keyvault.audit_log_analytics_id == [] ? ["${module.shared_infra_insights[each.key].log_analytics_workspace_id}"] : each.value.keyvault.audit_log_analytics_id
  retention_days             = each.value.keyvault.diag_retention_days
  depends_on                 = [module.shared_keyvault]
}

module "shared_sql_diagnostic" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.shared_infra
  name                       = each.value.sqlserver.diag_settings_name
  resource_id                = module.shared_infra_sql[each.key].mssql_server_id
  logs_destinations_ids      = each.value.sqlserver.audit_log_analytics_id == [] ? ["${module.shared_infra_insights[each.key].log_analytics_workspace_id}"] : each.value.sqlserver.audit_log_analytics_id
  retention_days             = each.value.sqlserver.diag_retention_days
  depends_on                 = [module.shared_infra_sql]
}