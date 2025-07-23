variable "resource_group_name" {
  description = "The name of the resource group where the VNet resides."
  type        = string
}

variable "vnet_name" {
  description = "The name of the Virtual Network to which these subnets belong."
  type        = string
}

variable "subnets" {
  description = "A map of subnet configurations for the VNet."
  type = map(object({
    name             = string
    address_prefixes = list(string)
    service_endpoints = optional(list(string), [])
    delegations = optional(list(object({
      name               = string
      service_delegation = object({
        name = string
        actions = optional(list(string), [])
      })
    })), [])
  }))
}