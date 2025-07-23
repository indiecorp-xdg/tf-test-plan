output "vnet_id" {
  description = "The ID of the created Virtual Network."
  value       = module.network.vnet_id
}

output "subnet_ids" {
  description = "Map of created subnet IDs."
  value       = module.subnets.subnet_ids
}