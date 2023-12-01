variable "static_app_name" {
  description = "Static web app name"
}

variable "resource_group_name" {
  description = "Resource group name"
}

variable "location" {
  description = "Static web app location"
}

variable "static_sku_tier" {
  description = "Static web app sku tier"
}

variable "static_sku_size" {
  description = "Static web app sku size"
}

variable "tags" {
  description = "Static web app tags"
}

variable "app_insights_intrumentation_key" {
  description = "App insighs intrumentation key to link it to app insight"
}

variable "ApiBasePath" {
  description = "Api Base Path URL"
}