resource "azurerm_container_app" "container_app" {
  name                         = var.container_app_name
  container_app_environment_id = var.container_app_env_id
  resource_group_name          = var.resource_group_name
  revision_mode                = var.revision_mode

  template {

    max_replicas = var.max_replicas
    container {
      name   = var.container_name
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = var.container_cpu
      memory = var.container_memory
      dynamic "env" {
        for_each = var.container_env
        content {
          name  = env.key
          value = env.value
        }
      }
    }
  }
dynamic "ingress" {
 for_each = var.ingress != {} ? [var.ingress] : []
 content {
    allow_insecure_connections = lookup(ingress.value, "allow_insecure_connections", null)
    external_enabled           = lookup(ingress.value, "external_enabled", null)
    target_port                = lookup(ingress.value, "target_port", null)
    transport                 = lookup(ingress.value, "transport", null)

    traffic_weight {
      latest_revision = lookup(ingress.value, "latest_revision", null)
      percentage      = lookup(ingress.value, "percentage", null)
    }
 }
}

dynamic "registry" {
  for_each = var.container_app_registry
  content {
    identity = registry.value.container_app_registry_identity
    server   = registry.value.container_registry_server
  }
}
  identity {
    type = "SystemAssigned"
  }
}