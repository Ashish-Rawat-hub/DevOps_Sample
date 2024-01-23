variable "principal_id" {
  description = "The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to"
}

variable "role_definition_name" {
  description = "The name of a built-in Role"
}

variable "rbac_scope" {
  description = "The scope at which the Role Assignment applies to"
}

variable "skip_service_principal_aad_check" {
  description = "If the principal_id is a newly provisioned Service Principal set this value to true to skip the Azure Active Directory check which may fail due to replication lag"
  default = false
}