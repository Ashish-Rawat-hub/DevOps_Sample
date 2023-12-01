locals {
  sqldb_init_script_file = "create user [${var.sql_userid}] from external provider with default_schema = dbo ; ALTER ROLE db_owner ADD MEMBER [${var.sql_userid}]"
}

resource "null_resource" "create_sql" {
  count = var.initialize_sql_script_execution ? 1 : 0
  provisioner "local-exec" {
    command = "sqlcmd -I -U '${var.sql_administrator_user}' -P '${var.sql_administrator_user_password}' -S '${var.sqlserver_fully_qualified_domain_name}' -d '${var.sqldb_name}' -Q '${local.sqldb_init_script_file}'"
  }
}