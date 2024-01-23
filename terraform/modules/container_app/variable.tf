variable "container_app_name" {
    description = "The name for this Container App"
}

variable "container_app_env_id" {
    description = "The ID of the Container App Environment within which this Container App should exist."
}

variable "resource_group_name" {
    description = "The name of the resource group in which the Container App Environment is to be created"
}

variable "revision_mode" {
    description = "The revisions operational mode for the Container App. Possible values include Single and Multiple"
    default     = "Single"
}

variable "ingress" {
  description = "Ingress block for the container app"
  default = {}
}

variable "container_name" {
  description = "The name of the container"
}

variable "container_cpu" {
  description = "The amount of vCPU to allocate to the container."
  default = 0.25
}

variable "container_memory" {
  description = "The amount of memory to allocate to the container"
  default = "0.5Gi"
}

variable "max_replicas" {
  description = "The maximum number of replicas for this container"
  default = 1
}

variable "container_env" {
  description = "Environment variables for the container"
  default = {}
}

variable "container_app_registry" {
  description = "Container registry details"
  default = []
}