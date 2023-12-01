output "runbook_name" {
  value = azurerm_automation_runbook.runbook.name
}

output "webhook_uri" {
  value = azurerm_automation_webhook.webhook.uri
}

output "webhook_resource_id" {
  value = azurerm_automation_webhook.webhook.id
}