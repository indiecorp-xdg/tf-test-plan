output "subnet_ids" {
  description = "A map of the created subnet IDs (key is the map key from input, value is subnet ID)."
  value       = { for name, subnet in azurerm_subnet.main : name => subnet.id }
}

output "subnet_names" {
  description = "A map of the created subnet names (key is the map key from input, value is subnet name)."
  value       = { for name, subnet in azurerm_subnet.main : name => subnet.name }
}