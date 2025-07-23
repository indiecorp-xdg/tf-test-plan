resource "azurerm_network_security_group" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "main" {
  for_each                    = { for idx, rule in var.security_rules : rule.name => rule } 
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = lookup(each.value, "source_port_range", null)
  destination_port_range      = lookup(each.value, "destination_port_range", null)
  source_address_prefix       = lookup(each.value, "source_address_prefix", null)
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", null)
  source_address_prefixes     = lookup(each.value, "source_address_prefixes", null)
  destination_address_prefixes = lookup(each.value, "destination_address_prefixes", null)
  resource_group_name         = azurerm_network_security_group.main.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
}