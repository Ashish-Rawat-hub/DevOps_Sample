## DESC: Azure rbac access
## Toggle: Type object rbac
module "rbac" {
  source         = "./modules/rbac"
  azurerm_access = var.azurerm_access
}