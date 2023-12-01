resource "azurerm_monitor_activity_log_alert" "main" {
  name                = var.alert_name
  resource_group_name = var.resource_group_name
  scopes              = [var.scope]
  description         = var.alert_description
  criteria {
    resource_id    = var.resource_id
    category       = "ResourceHealth"
    resource_health {
      current      = ["Unavailable","Degraded"]
      previous     = ["Available"]
      reason       = ["PlatformInitiated"]
    }
  }

  action {
    action_group_id = var.action_group_id
  }
  tags = var.tags
}