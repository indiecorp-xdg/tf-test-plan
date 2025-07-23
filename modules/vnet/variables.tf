variable "resource_group_name" {
  description = "The name of the Resource Group where the VNet will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the VNet will be created."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space (CIDR block) for the Virtual Network."
  type        = list(string)
}

variable "dns_servers" {
  description = "A list of IP addresses of DNS servers for the Virtual Network."
  type        = list(string)
  default     = []
}



variable "tags" {
  description = "A map of tags to assign to the VNet."
  type        = map(string)
  default     = {}
}