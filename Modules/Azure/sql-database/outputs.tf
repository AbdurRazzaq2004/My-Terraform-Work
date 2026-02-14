output "server_id" {
  description = "ID of the SQL server"
  value       = azurerm_mssql_server.this.id
}

output "server_fqdn" {
  description = "FQDN of the SQL server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_id" {
  description = "ID of the SQL database"
  value       = azurerm_mssql_database.this.id
}

output "database_name" {
  description = "Name of the SQL database"
  value       = azurerm_mssql_database.this.name
}

output "connection_string" {
  description = "ADO.NET connection string"
  value       = "Server=tcp:${azurerm_mssql_server.this.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.this.name};Persist Security Info=False;User ID=${var.admin_login};Password=${var.admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}
