output "mssql_server_id" {
  description = "the Microsoft SQL Server ID"
  value       = try(azurerm_mssql_server.sqlserver[0].id, "")
}

output "mssql_server_fqdn" {
  description = "The fully qualified domain name of the Azure SQL Server"
  value       = try(azurerm_mssql_server.sqlserver[0].fully_qualified_domain_name, "")
}


# output "mssql_connection_string" {
#   description = "Connection string for the Azure SQL Database created."
#   value       = "Server=tcp:${azurerm_mssql_server.mssql_server[0].fully_qualified_domain_name},1433;Initial Catalog=${var.mssql_db_name};Persist Security Info=False;User ID=${azurerm_mssql_server.mssql_server[0].administrator_login};Password=${azurerm_mssql_server.mssql_server[0].administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
# }

/* output "mssql_server_username" {
  description = "the Microsoft SQL Server ID"
  value       = try(azurerm_mssql_server.mssql_server[0].administrator_login, "")
}

output "mssql_server_userpass" {
  description = "the Microsoft SQL Server ID"
  value       = try(azurerm_mssql_server.mssql_server[0].administrator_login_password, "")
} */

/* output "sqldb_id" {
  description = "output of sql server db"
  value       = try(azurerm_mssql_database.sqldb[0].id, "")
} */