output "logic_app_id" {
  description = "The Logic App Workflow ID."  
  value = azurerm_logic_app_workflow.availability.id
}