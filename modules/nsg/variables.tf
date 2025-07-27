variable "name" {
  description = "The name of the Network Security Group."
  type        = string
}

variable "location" {
  description = "The Azure region where the NSG will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the NSG will be created."
  type        = string
}

variable "security_rules" {
  description = "A list of security rule objects for the NSG."
  type = list(object({
    name                        = string
    priority                    = number
    direction                   = string # "Inbound" or "Outbound"
    access                      = string # "Allow" or "Deny"
    protocol                    = string # "Tcp", "Udp", "Icmp", "*", or a port number
    source_port_range           = optional(string, null)
    source_port_ranges           = optional(list(string), null)
    destination_port_range      = optional(string, null)
    destination_port_ranges      = optional(list(string), null)
    source_address_prefix       = optional(string, null)
    source_address_prefixes     = optional(list(string), null)
    destination_address_prefix  = optional(string, null)
    destination_address_prefixes = optional(list(string), null)
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the NSG."
  type        = map(string)
  default     = {}
}