# Add all azurerm access to Azure AD group
resource "azurerm_role_assignment" "az_rbac" {
  for_each             = {for rbac in var.azurerm_access : rbac.name => rbac}
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}