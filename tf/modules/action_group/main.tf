resource "azurerm_monitor_action_group" "action_group" {
  count               = var.create_action_group ? 1 : 0
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = "action group"
  tags                = var.tags
  automation_runbook_receiver {
    name                         = var.runbook_receiver_name
    automation_account_id        = var.automation_account_id
    runbook_name                 = var.runbook_name
    webhook_resource_id          = var.webhook_resource_id
    is_global_runbook            = true
    service_uri                  = var.webhook_uri
    use_common_alert_schema      = true

  }
}