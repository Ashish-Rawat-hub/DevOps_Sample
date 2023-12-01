output "random_string" {
  value = random_string.unique.result
}

######################################################
## App Service
######################################################
/* output "app_service_id" {
  description = "Id of the app service"
  value       = try(module.app_service["{{env}}"].app_service_id, "")
} */

output "app_service_hostname" {
  description = "Default hostname of the app service"
  value       = try(module.app_service["{{env}}"].default_hostname, "")
}

######################################################
## Function App Service
######################################################
output "function_app_hostname" {
  description = "Default hostname of the function app"
  value       = try(module.functionapp["{{env}}"].function_app_hostname, null)
}

/* output "sqldb_id" {
  description = "Id of Azure Sql DB"
  value       = try(module.shared_infra_sqldb["{{env}}"].sqldb_id, null)
} */


#########################################
## Subnet Output
#########################################
# output "FUNCTIONAPPsub" {
#   description = "The ids of subnets created inside the newl vNet"
#   value = module.shared_infra_vnet[each.key].vnet_subnets["FUNCTIONAPPsubnet"].id
# }

# output "DEVsub" {
#   description = "The ids of subnets created inside the newl vNet"
#   value = module.shared_infra_vnet[each.key].vnet_subnets["DEVsubnet"].id
# }

# output "app_service_id" {
#   description = "Default Hostname of the app service"
#   #value       = try(module.fdb_infra_appservice.app_service_id, null)
#   value       = module.fdb_infra_appservice["{{env}}"].app_service_id
# }

# output "default_hostname" {
#   description = "Default Hostname of the app service"
#   #value       = try(module.fdb_infra_appservice.default_hostname, null)
#   value       = module.fdb_infra_appservice["{{env}}"].default_hostname
# }

# output "apim_public_ip_addresses" {
#   description = "Public Ip of the API Management Service"
#   value       = module.fdb_infra_apim["test"].apim_public_ip_addresses
# }

# output "mssql_connection_string" {
#   value = module.shared_infra_sql["test"].mssql_connection_string
#   sensitive = false
# }

# output "sqldb_connectionstring" {
#   value = module.fdb_infra_key_vault_secrets["test"].sqldb_connectionstring
# }

# output "sqlserver_pass" {
#   value = module.fdb_infra_key_vault_secrets["test"].sqlServer_pass
# }

# output "object_id" {
#   value = module.fdb_infra_keyvault["test"].object_id
# }

# output "resource_group_id" {
#   value = module.shared_infra_rg["{{env}}"].resource_group_id
# }

# output "key_vault_secret_cosmosdbaccount_id" {
#   value = "${module.fdb_infra_keyvault["{{env}}"].key_vault_secrets["SqlDBConnectionString-{{env}}"].id}"
# }

# output "key_vault_secret_cosmosdbaccount_resource_id" {
#   value = "${module.fdb_infra_keyvault["{{env}}"].key_vault_secrets["SqlDBConnectionString-{{env}}"].resource_id}"
# }

# output "key_vault_secret_cosmosdbaccount_version" {
#   value = "${module.fdb_infra_keyvault["{{env}}"].key_vault_secrets["SqlDBConnectionString-{{env}}"].version}"
# }

