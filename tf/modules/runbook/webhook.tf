resource "azurerm_automation_webhook" "webhook" {
  name                    = var.webhook_name
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_acc_name
  expiry_time             = var.webhook_expiry_date
  enabled                 = true
  runbook_name            = azurerm_automation_runbook.runbook.name
  parameters = {
    to_email              = var.to_email,
    from_email            = var.from_email
  }
}