output "nsg_id" {
  description = "The ID of the created Network Security Group."
  value       = azurerm_network_security_group.main.id
}

output "nsg_name" {
  description = "The name of the created Network Security Group."
  value       = azurerm_network_security_group.main.name
}