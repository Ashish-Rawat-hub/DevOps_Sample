/* module "diagnostics" {
  source                = "../diagnostic_setting"
  name                  = upper("${var.name}-diag")
  resource_id           = join(",", azurerm_key_vault.keyvault.*.id)
  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories
  retention_days        = var.logs_retention_days
} */
