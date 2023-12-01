################################################################
## Azure Main SQL Database
################################################################
module "sqldb" {
  source                            = "./modules/sql_db/v1"
  for_each                          = var.mssqldb
  resource_group_name               = each.value.resource_group_name
  create_sql_db                     = each.value.create_sql_db
  sql_db_name                       = each.value.sql_db_name
  sqlservername                     = each.value.sqlservername
  sku_name                          = each.value.sku_name
  collation                         = each.value.collation
  license_type                      = each.value.license_type
  read_scale                        = each.value.read_scale
  zone_redundant                    = each.value.zone_redundant
  create_secondary_db               = each.value.create_secondary_db
  primary_sqldb_id                  = each.value.primary_sqldb_id
  threat_detection_policy           = each.value.threat_detection_policy
  tags                              = merge(local.tags, var.tags)
}

# ################################################################
# ## Azure Disaster Recovery SQL Database
# ################################################################
# module "dr_sqldb" {
#   source                            = "./modules/sql_db/v1"
#   for_each                          = var.shared_infra
#   resource_group_name               = each.value.dr_resource_group_name
#   create_sql_db                     = each.value.dr_sqldb.create_sql_db
#   sql_db_name                       = each.value.dr_sqldb.sql_db_name
#   sqlservername                     = each.value.dr_sqldb.sqlservername
#   sku_name                          = each.value.dr_sqldb.sku_name
#   collation                         = each.value.dr_sqldb.collation
#   license_type                      = each.value.dr_sqldb.license_type
#   read_scale                        = each.value.dr_sqldb.read_scale
#   zone_redundant                    = each.value.dr_sqldb.zone_redundant
#   create_secondary_db               = each.value.dr_sqldb.create_secondary_db
#   primary_sqldb_id                  = each.value.dr_sqldb.primary_sqldb_id == null ? module.shared_infra_sqldb[each.key].sqldb_id : each.value.dr_sqldb.primary_sqldb_id
#   threat_detection_policy           = each.value.dr_sqldb.threat_detection_policy
#   tags                              = merge(local.tags, var.tags)
# }

module "sqldb_master_diagnostic" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.mssqldb
  name                       = "${each.value.diagnostic_setting.diagnostic_name}-master"
  resource_id                = "${module.sqldb[each.key].sql_server_id}/databases/master"
  logs_destinations_ids      = each.value.diagnostic_setting.log_analytics_workspace_id
  retention_days             = each.value.diagnostic_setting.retention_days
}

module "sqldb_diagnostic" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.mssqldb
  name                       = each.value.diagnostic_setting.diagnostic_name
  resource_id                = "${module.sqldb[each.key].sql_server_id}/databases/${each.value.sql_db_name}"
  logs_destinations_ids      = each.value.diagnostic_setting.log_analytics_workspace_id
  retention_days             = each.value.diagnostic_setting.retention_days
}