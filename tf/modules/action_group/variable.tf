variable "create_action_group" {
  description = "Control toggle to control the creation of action group"
  type = bool
  default = false
}

variable "tags" {
  description = "Extra tags to add."
  type        = map(string)
}

variable "action_group_name" {
  type = string
  description = "Name of Alert Action Group"
}

variable "resource_group_name" {
  type = string
  description = "Name of Resource Group"
}

variable "automation_account_id" {
  description = "Automation account id"
}

variable "runbook_receiver_name" {
  description = "Name of the automation action for runbook"
}
variable "runbook_name" {
  
}

variable "webhook_resource_id" {
  
}

variable "webhook_uri" {
  
}