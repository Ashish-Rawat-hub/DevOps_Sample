output "sqldb_id" {
  description = "Id of sql server db"
  value       = try(azurerm_mssql_database.sqldb[0].id, "")
}

output "sql_server_id" {
  description = "Id of sql server"
  value = try(data.azurerm_mssql_server.sql_server[0].id, "")
}