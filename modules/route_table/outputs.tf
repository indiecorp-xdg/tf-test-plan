output "route_table_id" {
  description = "The ID of the created Route Table."
  value       = azurerm_route_table.main.id
}

output "route_table_name" {
  description = "The name of the created Route Table."
  value       = azurerm_route_table.main.name
}
