output "name" {
  description = "The name of the Resource Group."
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "The Azure region where the Resource Group is located."
  value       = azurerm_resource_group.main.location
}

output "id" {
  description = "The ID of the Resource Group."
  value       = azurerm_resource_group.main.id
}