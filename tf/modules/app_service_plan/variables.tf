variable "resource_group_name" {
  description = "The name of the resource group in which to create the App Service Plan component"
  type        = string
}

variable "asp_name" {
  description = "Specifies the name of the App Service Plan component"
  type        = string
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists"
  type        = string
}

variable "sku_name" {
  description = "The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1."
  type        = string
}

# variable "app_service_environment_id" {
#   description = "The ID of the App Service Environment where the App Service Plan should be located"
#   type        = string
# }

variable "os_type" {
  description = "A sku block containing tier, size, and capacity specifications"
  type        = string
}

# variable "reserved" {
#   description = "Is this App Service Plan Reserved"
#   type        = bool
# }

variable "tags" {
  description = "Tags for the app service plan"
  type        = map(any)
}
