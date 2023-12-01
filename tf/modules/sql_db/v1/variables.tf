variable "create_sql_db" {
  description = "Set true to create the sql db"
  default = true
}

variable "resource_group_name" {
  description = "The name of the resource group of the SQL DB"
  type        = string
}

variable "sql_db_name" {
  description = "Name of the SQL DB"
  type        = string
}

variable "sqlservername" {
  description = "Name of the SQL Server"
  type        = string
}

variable "sku_name" {
  description = "SQL DB SKU"
  type        = string
  default     = "Basic"
}

variable "collation" {
  description = "Name of the SQL DB Collation"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "license_type" {
  description = "SQL DB License type"
  type        = string
  default     = "LicenseIncluded"
}

variable "read_scale" {
  description = "SQL DB read scale"
  type        = bool
  default     = false
}

variable "zone_redundant" {
  description = "SQL DB zone_redundant"
  type        = bool
  default     = false
}

variable "create_secondary_db" {
  description = "create mode for secodary (backup) db"
  type        = bool
  default     = null
}

variable "primary_sqldb_id" {
  description = "sql db id for secodary (backup) db"
  type        = string
  default     = null
}

variable "threat_detection_policy" {
  description = "(Required) threat detection policy if state is enabled"
  default = []
}

variable "tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}