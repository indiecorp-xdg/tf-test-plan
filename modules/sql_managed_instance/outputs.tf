# modules/sql_managed_instance/outputs.tf

output "sql_mi_id" {
  description = "The ID of the SQL Managed Instance."
  value       = azurerm_mssql_managed_instance.main.id
}

output "sql_mi_fqdn" {
  description = "The FQDN of the SQL Managed Instance."
  value       = azurerm_mssql_managed_instance.main.fqdn
}

output "private_endpoint_id" {
  description = "The ID of the Private Endpoint for the SQL Managed Instance."
  value       = azurerm_private_endpoint.sql_mi_pe.id
}