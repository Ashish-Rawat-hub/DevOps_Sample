variable "resource_group_name" {
  description = "The name of the resource group of the SQL DB"
  type        = string
}

variable "location" {
  description = "The location of the SQL DB"
  type        = string
}

variable "mssql_server_name" {
  description = "The name of the SQL Server"
  type        = string
}

variable "mssql_server_version" {
  description = "The version of the SQL DB"
  type        = string
  default     = "12.0"
}

# variable "administrator_login" {
#   description = "The Administrator login of the SQL DB"
#   type        = string
# }

# variable "administrator_login_pass" {
#   description = "The Administrator login Password of the SQL DB"
#   type        = string
# }

variable "minimum_tls_version" {
  description = "minimum_tls_version"
  type        = string
  default     = "1.2"
}

variable "max_size_gb" {
  default = 1
}

variable "create_virtual_network_rule" {
  description = "Control toggle to control creation of resources"
  type        = bool
  default     = false
}

variable "create_private_endpoint" {
  description = "Control toggle to control creation of resources"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "(Required) Private endpoint subnet_id"
  default = ""
}

variable "sql_virtual_network_rule_name" {
  description = "(Required) SQL virtual network rule subnet_id"
  default = ""
}

variable "sql_virtual_network_endpoint_name" {
  description = "(Required) SQL virtual network rule subnet_id"
  default = ""
}

variable "sql_virtual_network_rule_subnet_id" {
  description = "(Required) SQL virtual network rule subnet_id"
  default = ""
}

# variable "private_dns_zone_group" {
#   description = "new private_dns_zone_group resource to be created"
#   default = []
# }

# variable "allow_ip_address" {
#   description = "allow_ip_address resource to be accees sql server"
# }

variable "virtual_network_id" {
  description = "Virtual network id"
  default = []
}


variable "tags" {
  description = "Extra tags to add"
  type        = map(string)
  default     = {}
}

variable "public_network_access_enabled" {
  description = "Whether public access is enables for sql server or not"
  type        = bool
  default     = false
}
                                                          
variable "storage_endpoint" {
  description = "The storage account blob storage endpoint"
  default = ""
}

variable "storage_account_access_key" {
  description = "The access key to use for the auditing storage account."
  default = ""
}

variable "storage_account_access_key_is_secondary" {
  description = "Is storage_account_access_key value the storage's secondary key?"
  type        = bool
  default     = false
}

variable "retention_in_days" {
  description = "The number of days to retain logs for in the storage account."
  default     = 0
}

variable "storage_account_name" {
  description = "Storage account name"
  default = ""
}

variable "storage_container_name" {
  description = "storage container name"
  default = ""
}

variable "recurring_emails" {
  description = "Specifies an array of email addresses to which the scan notification is sent."
  default = []
}

variable "recurring_email_subscription_admins" {
  description = "Boolean flag which specifies if the schedule scan notification will be sent to the subscription administrators."
  type = bool
  default = false
}

variable "recurring_scans_enabled" {
  description = "Boolean flag which specifies if recurring scans is enabled or disabled."
  type = bool
  default = false
}

variable "alert_policy_state" {
  description = "Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database server."
  default = ""
}

variable "storage_container_access_type" {
  description = "The Access Level configured for this Container."
  default = ""
}

variable "create_assessment" {
  description = "Boolean to choose whether to create vulnerability assessment or not"
  type        = bool
  default     = false
}

variable "private_dns_zone_group_name" {
  description = "Name of the private dns zone group"
  default = ""
}

variable "private_dns_zone_name" {
  description = "Name of the private dns zone"
  default = ""
}

variable "virtual_network_private_link_name" {
  description = "Name of the private dns zone group"
  default = ""
}

variable "sql_a_record_name" {
  description = "The name of the DNS A Record"
  default = ""
}

variable "dns_a_record_ttl" {
  description = "The Time To Live (TTL) of the DNS record in seconds."
  default = 10
}

variable "enable_geo_replication" {
  description = "Toggle to enable/disable geo replication for sql server"
  type = bool
  default = false
}

variable "location_secondary" {
  description = "Location for secondary sql server"
  default = "North US"
}

variable "principal_display_name" {
  description = "Service principal display name"
  default = ""
}

variable "secondary_sql_server_name" {
  description = "Name for the backup Sql Server"
  default = ""
}

variable "secondary_sql_db_name" {
  description = "Name for the backup Sql Database"
  default = ""
}

variable "secondary_resource_group_name" {
  description = "Name for the secondary resource group"
  default = ""
}

variable "enable_aad_authentication_only" {
  description = "Set true to enable Azure Active Directory Authentication on SQL Server"
  default = true
}

variable "create_sql_server" {
  description = "Set true to create the sql server"
  default = true
}