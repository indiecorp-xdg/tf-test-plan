resource "azurerm_mssql_managed_instance" "main" {
  name = var.sql_mi_name
  # resource_group_name           = azurerm_resource_group.mi_rg.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  license_type                 = var.license_type
  sku_name                     = var.sku_name
  vcores                       = var.vcores
  storage_size_in_gb           = var.storage_gb
  storage_account_type         = var.storage_account_type
  subnet_id                    = var.subnet_id
  collation                    = var.collation
  public_data_endpoint_enabled = false # Best practice for private connectivity
  minimum_tls_version          = "1.2"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  # dns_zone                      = var.sql_mi_name # Or another unique DNS zone name for MI
  tags = var.tags

  # Ensure the subnet has the correct delegation set up in the network module
  # For SQL MI, the delegation is `Microsoft.Sql/managedInstances`
}

resource "azurerm_mssql_managed_database" "main" {
  name                = "db.${azurerm_mssql_managed_instance.main.name}"
  managed_instance_id = azurerm_mssql_managed_instance.main.id
  lifecycle {
    prevent_destroy = true
  }
  tags = var.tags
}

# Private DNS Zone for Private Endpoint
resource "azurerm_private_dns_zone" "sql_mi_privatelink" {
  # name                = "privatelink.${data.azurerm_mssql_managed_instance.main.dns_zone_partner_host_names[0]}" # Or "privatelink.database.windows.net" for generic SQL
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_mssql_managed_instance.main.resource_group_name
  # resource_group_name = azurerm_resource_group.mi_rg.name # Use same RG as MI or specific DNS RG
  # You might need to adjust the zone name based on the exact MI DNS suffix or use the generic one.
  # For SQL MI, it's typically <mi_name>.database.windows.net or <mi_name>.<region>.database.windows.net
  # Data source will help if using pre-existing MI, or you can construct it
  tags = var.tags
}

# Link Private DNS Zone to the VNet where your clients (AKS, Web App) are
resource "azurerm_private_dns_zone_virtual_network_link" "sql_mi_vnet_link" {
  name                  = "${var.sql_mi_name}-vnet-link"
  resource_group_name   = azurerm_private_dns_zone.sql_mi_privatelink.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_mi_privatelink.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}

# Private Endpoint for SQL Managed Instance
resource "azurerm_private_endpoint" "sql_mi_pe" {
  name     = "${var.sql_mi_name}-pe"
  location = var.location
  # resource_group_name = azurerm_resource_group.mi_rg.name
  resource_group_name = azurerm_mssql_managed_instance.main.resource_group_name
  subnet_id           = var.subnet_id # The DB Subnet where the PE will reside
  tags                = var.tags

  private_service_connection {
    name                           = "${var.sql_mi_name}-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_managed_instance.main.id
    # subresource_names              = ["sqlManagedInstance"]
    subresource_names              = ["managedInstance"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_mi_privatelink.id]
  }
}
