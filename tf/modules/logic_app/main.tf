resource "azurerm_logic_app_workflow" "availability" {
  name                = var.workflow_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_resource_group_template_deployment" "name" {
    name                = var.template_deployment_name
    resource_group_name = var.resource_group_name
    template_content       = file("modules/logic_app/template.json")
    parameters_content = jsonencode({
      "workflow_name"            = {value = var.workflow_name}
      "location"                 = {value = var.location}
      "env"                      = {value = var.env}
      "function_id"              = {value = var.function_id}
      "frequency"                = {value = var.frequency}
      "interval"                 = {value = var.interval}
      "keyvault_function_name"   = {value = var.keyvault_function_name}
      "sqlserver_function_name"  = {value = var.sqlserver_function_name}
      "delay1_frequency"         = {value = var.keyvault_delay_frequency}
      "delay2_frequency"         = {value = var.sqlserver_delay_frequency}
      "delay1_unit"              = {value = var.keyvault_delay_unit}
      "delay2_unit"              = {value = var.sqlserver_delay_unit}
    })
    deployment_mode   = var.deployment_mode
}