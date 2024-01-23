resource "azurerm_role_assignment" "rbac" {
  principal_id                     = var.principal_id
  role_definition_name             = var.role_definition_name
  scope                            = var.rbac_scope
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}