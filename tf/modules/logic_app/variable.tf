variable "function_id" {
  description = "Id of the function to which this logic app will be linked"
}

variable "template_deployment_name" {
  description = "Name of the Resource group template deployment"
}

variable "resource_group_name" {
  description = "Resource group name of logic app"
}

variable "workflow_name" {
  description = "workflow name of the logic app"
}

variable "location" {
  description = "Location of the logic app"
}

variable "env" {
  description = "Environment of the logic app"
}

variable "frequency" {
  description = "Frequency of the logic app trigger"
}

variable "interval" {
  description = "Interval between each trigger frequency"
}

variable "deployment_mode" {
  description = "Deployment mode of the template deployment"
}

variable "keyvault_function_name" {
  description = "Name of the function which will check the availability of keyvault"
}

variable "sqlserver_function_name" {
  description = "Name of the function which will check the availability of Sql Server"
}

variable "keyvault_delay_frequency" {
  description = "Frequency of the keyvault delay"
}

variable "sqlserver_delay_frequency" {
  description = "Frequency of the SQL Server delay"
}

variable "keyvault_delay_unit" {
  description = "Time Unit of the keyvault delay"
}

variable "sqlserver_delay_unit" {
  description = "Time Unit of the SQL Server delay"
}