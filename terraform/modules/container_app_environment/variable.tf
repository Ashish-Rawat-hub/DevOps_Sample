variable "container_app_env_name" {
  description = "The name of the Container Apps Managed Environment."
}

variable "location" {
  description = "Specifies the supported Azure location where the Container App Environment is to exist."
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Container App Environment is to be created."
}

variable "log_analytics_workspace_id" {
  description = "The Log Analytics Workspace ID"
  default = ""
}