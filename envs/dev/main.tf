module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "tf-labs-rg"
  location = "South Africa North"
  tags = {
    environment = "Dev"
    project     = "tf-labs-3TierApp"
  }
}

module "network" {
  source              = "../../modules/vnet"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = "tf-3tier-vnet"
  vnet_address_space  = ["10.0.0.0/16"]
  dns_servers         = []



}

module "subnets" {
  source              = "../../modules/subnets"
  resource_group_name = module.resource_group.name
  vnet_name           = module.network.vnet_name
  subnets = {
    web_layer = {
      name             = "web-subnet"
      address_prefixes = ["10.0.1.0/24"]
      # Will associate NSG later
    },
    app_layer = {
      name             = "app-subnet"
      address_prefixes = ["10.0.2.0/24"]
      # This subnet is for AKS, AKS requires specific delegation, handled in NSG module logic
    },
    db_layer = {
      name             = "db-subnet"
      address_prefixes = ["10.0.3.0/24"]
      # This subnet is for Private Endpoint, requires specific delegation
      service_endpoints = ["Microsoft.Sql"]
      # service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"] # Example for Private Endpoint needs
      delegations = [{
        name = "managedSQLinstancedelegation"
        service_delegation = {
          name = "Microsoft.Sql/managedInstances"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
          ]
        }
      }]
    },
    aks_subnet = {
      name             = "aks-subnet"
      address_prefixes = ["10.0.4.0/24"]
      # AKS requires delegation, this would be defined for the AKS module or passed through ... For AKS, delegation is typically done by the AKS module itself.
    }
  }
}

module "web_nsg" {
  source              = "../../modules/nsg" # Adjust path if different
  name                = "tf-web-nsg"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  # Rules for Web Layer: 22, 80, 443 inbound
  security_rules = [
    {
      name                     = "AllowSSH"
      priority                 = 100
      direction                = "Inbound"
      access                   = "Allow"
      protocol                 = "Tcp"
      source_port_range        = "*"
      destination_port_range   = "22"
      source_address_prefix    = "Internet" # Or specific trusted IPs
      destination_address_prefix = "*"
    },
    {
      name                     = "AllowHTTP"
      priority                 = 110
      direction                = "Inbound"
      access                   = "Allow"
      protocol                 = "Tcp"
      source_port_range        = "*"
      destination_port_range   = "80"
      source_address_prefix    = "Internet"
      destination_address_prefix = "*"
    },
    {
      name                     = "AllowHTTPS"
      priority                 = 120
      direction                = "Inbound"
      access                   = "Allow"
      protocol                 = "Tcp"
      source_port_range        = "*"
      destination_port_range   = "443"
      source_address_prefix    = "Internet"
      destination_address_prefix = "*"
    }
    # Add rules for internal communication (e.g., to App Layer)
  ]
}

module "app_nsg" {
  source              = "../../modules/nsg"
  name                = "tf-app-nsg"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  # Rules for App Layer (AKS): Internal traffic
  security_rules = [
    {
      name                     = "AllowInboundFromWeb"
      priority                 = 100
      direction                = "Inbound"
      access                   = "Allow"
      protocol                 = "Tcp"
      source_port_range        = "*"
      destination_port_range   = "8080"
      source_address_prefix    = module.subnets.subnet_cidrs["web_layer"]
      destination_address_prefix = "*"
    },
    {
      name                     = "AllowOutboundToDB"
      priority                 = 100
      direction                = "Outbound"
      access                   = "Allow"
      protocol                 = "Tcp"
      source_port_range        = "*"
      destination_port_range   = "3306"
      source_address_prefix    = "*"
      destination_address_prefix = module.subnets.subnet_cidrs["db_layer"]
    }
    # AKS will add its own rules, ensure no conflict
  ]
}

module "db_nsg" {
  source              = "../../modules/nsg"
  name                = "tf-db-nsg"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  security_rules = [
    {
      name                     = "AllowPrivateEndpointAccess"
      priority                 = 100
      direction                = "Inbound"
      access                   = "Allow"
      protocol                 = "Tcp"
      source_port_range        = "*"
      destination_port_range   = "3306"
      source_address_prefix    = "VirtualNetwork"
      destination_address_prefix = "*"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "web_nsg_association" {
  subnet_id                 = module.subnets.subnet_ids["web_layer"]
  network_security_group_id = module.web_nsg.nsg_id
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_association" {
  subnet_id                 = module.subnets.subnet_ids["app_layer"]
  network_security_group_id = module.app_nsg.nsg_id
}

resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
  subnet_id                 = module.subnets.subnet_ids["db_layer"]
  network_security_group_id = module.db_nsg.nsg_id
}