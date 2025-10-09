output "sql_server_name" {
  description = "The name of the SQL server"
  sensitive   = false
  value       = azurerm_mssql_server.sql_server.name
}
output "sql_server_id" {
  description = "The ID of the SQL server"
  sensitive   = false
  value       = azurerm_mssql_server.sql_server.id
}
output "administrator_login_password" {
  sensitive = false
  value     = azurerm_mssql_server.sql_server.administrator_login_password
}
output "sql_database_name" {
  description = "The name of the SQL database"
  sensitive   = false
  value       = azurerm_mssql_database.sql_database.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL server"
  sensitive   = false
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
