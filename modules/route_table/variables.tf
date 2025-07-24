variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

variable "route_table_name" {
  description = "Name of the Azure Route Table."
  type        = string
}

# variable "route_name" {
#   description = "Name of the individual route within the route table."
#   type        = string
# }

# variable "address_prefix" {
#   description = "The destination CIDR to which the route applies."
#   type        = string
# }

# variable "next_hop_type" {
#   description = "The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance, and None."
#   type        = string
#   # default     = "VirtualAppliance"
#   validation {
#     condition     = contains(["VirtualNetworkGateway", "VnetLocal", "Internet", "VirtualAppliance", "None"], var.next_hop_type)
#     error_message = "Valid next_hop_type values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance, None."
#   }
# }

# variable "next_hop_in_ip_address" {
#   description = "The IP address of the next hop (if next_hop_type is VirtualAppliance)."
#   type        = string
# }

variable "bgp_route_propagation_enabled" {
  description = "Boolean flag which controls whether BGP routes are propagated to this route table."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default = {}
}

# variable "route_definition" {
#   description = "A map defining a single optional route to be created with the route table. Set to null if no route is desired."
#   type = object({
#     name                 = string
#     address_prefix       = string
#     next_hop_type        = string
#     next_hop_in_ip_address = optional(string) # optional if next_hop_type doesn't require it
#   })
#   default = null # This makes the entire route optional
# }


variable "route_definitions" {
  description = "A list of objects, where each object defines a route to be created within the route table. Leave empty for no routes."
  type = list(object({
    name                 = string
    address_prefix       = string
    next_hop_type        = string
    next_hop_in_ip_address = optional(string) # 'optional' makes this field optional within each route object
  }))
  default = [] # Default to an empty list, meaning no routes will be created by default
}