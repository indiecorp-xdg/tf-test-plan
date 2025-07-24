# resource "azurerm_route_table" "main" {
#   name                          = var.route_table_name
#   location                      = var.location
#   resource_group_name           = var.resource_group_name
#   bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
#   tags = var.tags

#     dynamic "route" {
#     for_each = var.route_definitions # Iterate over the list of route definitions
#     content {
#       name                   = route.value.name
#       address_prefix         = route.value.address_prefix
#       next_hop_type          = route.value.next_hop_type
#       next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null) # Use lookup for truly optional attributes
#     }
#   }
# }

# resource "azurerm_route" "main" {
#   name                = var.route_name
#   resource_group_name = azurerm_route_table.main.resource_group_name
#   route_table_name    = azurerm_route_table.main.name
#   next_hop_type       = var.next_hop_type
#   next_hop_in_ip_address = var.next_hop_in_ip_address
#   address_prefix      = var.address_prefix
# }

resource "azurerm_route_table" "main" {
  name                          = var.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = var.bgp_route_propagation_enabled
  tags                          = var.tags

  # Use dynamic block for optional/multiple 'route' blocks
  dynamic "route" {
    for_each = var.route_definitions # Iterate over the list of route definitions
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null) # Use lookup for truly optional attributes
    }
  }
}