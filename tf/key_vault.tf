##Create a resource group for the Key Valut
module "key_valut_rg" {
  source      = "./modules/resource_group"
  for_each    = var.keyvaults
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}

## Create Key Vault
module "key_vault" {
  source                     = "./modules/key_vault"
  for_each                   = var.keyvaults
  resource_group_name        = each.value.create_resource_group == true ? module.key_valut_rg[each.key].resource_group_name : each.value.resource_group_name
  create_key_vault           = each.value.create_key_vault
  location                   = each.value.location
  name                       = "${each.value.key_vault_name}-${random_string.unique.result}"
  create_private_endpoint    = each.value.create_private_endpoint == null ? false : each.value.create_private_endpoint
  private_endpoint_subnet_id = each.value.private_endpoint_subnet_id
  master_key_vault_id        = each.value.master_key_vault_id == null ? "" : each.value.master_key_vault_id
  key_vault_secrets          = []
  secret_expiration_date     = each.value.secret_expiration_date == null ? null : each.value.secret_expiration_date
  network_acls               = each.value.network_acls
  virtual_network_subnet_ids = each.value.virtual_network_subnet_ids
  object_id                  = local.object_id
  tenant_id                  = local.tenant_id  
  tags                       = merge(local.tags, var.tags)
}

module "key_vault_secrets" {
  source                     = "./modules/key_vault/key_vault_secrets"
  for_each                   = var.keyvaults
  master_key_vault_id        = each.value.master_key_vault_id == null ? "" : each.value.master_key_vault_id
  key_vault_secrets          = []
  secret_expiration_date     = each.value.secret_expiration_date == null ? null : each.value.secret_expiration_date
  key_vault_id               = module.key_vault[each.key].key_vault_id
  admin_objects_ids          = each.value.admin_objects_ids == null ? [] : each.value.admin_objects_ids
  tenant_id                  = local.tenant_id
  reader_objects_ids         = concat(try(["${module.app_service["{{env}}"].app_service_identity.0.principal_id}"], []), each.value.reader_objects_ids)
  master_secret_name         = each.value.master_secret_name == null ? [] : each.value.master_secret_name
  depends_on                 = [module.key_vault]
}

module "key_vault_diagnostic" {
  source                     = "./modules/diagnostic_setting"
  for_each                   = var.keyvaults
  name                       = each.value.diag_settings_name
  resource_id                = module.key_vault[each.key].key_vault_id
  logs_destinations_ids      = each.value.audit_log_analytics_id
  retention_days             = each.value.diag_retention_days
  depends_on                 = [module.key_vault]
}