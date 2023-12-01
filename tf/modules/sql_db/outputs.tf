output "mssql_server_id" {
  description = "the Microsoft SQL Server ID"
  value       = azurerm_mssql_database.mssql_database.id
}

output "mssql_server_fqdn" {
  description = "The fully qualified domain name of the Azure SQL Server"
  value       = azurerm_mssql_database.mssql_database.name
}