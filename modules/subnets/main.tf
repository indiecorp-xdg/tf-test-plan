# Dynamically create subnets based on the 'subnets' input map
resource "azurerm_subnet" "main" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", null) # Handle optional service_endpoints

  dynamic "delegation" {
    for_each = lookup(each.value, "delegations", []) # Iterate over the delegations if they exist, otherwise an empty list
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = lookup(delegation.value.service_delegation, "actions", [])
      }
    }
  }
}