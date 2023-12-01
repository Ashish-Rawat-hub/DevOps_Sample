
locals {
  identity = merge({
    type = "SystemAssigned"
    ids  = null
  }, var.identity)
}
