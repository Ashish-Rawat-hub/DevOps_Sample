##Create a resource group for the Automation Account
module "automation_acc_rg" {
  source      = "./modules/resource_group"
  for_each    = var.automation_acc
  create      = each.value.create_resource_group == true ? true : false
  environment = var.environment
  location    = each.value.location
  rg_name     = each.value.resource_group_name
  tags        = merge(local.tags, var.tags)
}

module "automation_account" {
  source              = "./modules/automation_account"
  for_each            = var.automation_acc
  automation_acc_name = each.value.automation_acc_name
  resource_group_name = each.value.create_resource_group == true ? module.automation_acc_rg[each.key].resource_group_name : each.value.resource_group_name
  location            = each.value.create_resource_group == true ? module.automation_acc_rg[each.key].resource_group_location : each.value.location
  automation_acc_sku  = each.value.automation_acc_sku
  tags                = merge(local.tags, var.tags)
  depends_on          = [module.automation_acc_rg]
}

module "runbook" {
  source              = "./modules/runbook"
  for_each            = var.automation_acc
  automation_acc_name = module.automation_account[each.key].automation_account_name
  resource_group_name = each.value.create_resource_group == true ? module.automation_acc_rg[each.key].resource_group_name : each.value.resource_group_name
  location            = each.value.create_resource_group == true ? module.automation_acc_rg[each.key].resource_group_location : each.value.location
  runbook_name        = each.value.runbook_name
  log_verbose         = each.value.log_verbose
  log_progress        = each.value.log_progress
  runbook_description = each.value.runbook_description
  runbook_type        = each.value.runbook_type
  webhook_name        = each.value.webhook_name
  webhook_expiry_date = each.value.webhook_expiry_date
  to_email            = each.value.to_email
  from_email          = each.value.from_email
  tags                = merge(local.tags, var.tags)
  depends_on          = [module.automation_acc_rg, module.automation_account]
}

module "action_group" {
  source                = "./modules/action_group"
  for_each              = var.automation_acc
  create_action_group   = each.value.create_action_group == true ? true : false
  action_group_name     = each.value.action_group_name
  resource_group_name   = each.value.create_resource_group == true ? module.automation_acc_rg[each.key].resource_group_name : each.value.resource_group_name
  automation_account_id = module.automation_account[each.key].automation_account_id
  runbook_name          = module.runbook[each.key].runbook_name
  runbook_receiver_name = each.value.runbook_receiver_name
  webhook_resource_id   = module.runbook[each.key].webhook_resource_id
  webhook_uri           = module.runbook[each.key].webhook_uri
  tags                  = merge(local.tags, var.tags)
  depends_on            = [module.automation_acc_rg, module.automation_account, module.runbook]
}