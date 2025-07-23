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
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"] # Example for Private Endpoint needs
      delegations = [{
        name = "microsoft-sql-delegation"
        service_delegation = {
          name = "Microsoft.Sql/managedInstances"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
          ] # Optional, depends on exact scenario
        }
      }]
    },
    aks_subnet = {
      name             = "aks-subnet"
      address_prefixes = ["10.0.4.0/24"]
      # AKS requires delegation, this would be defined for the AKS module or passed through
      # For AKS, delegation is typically done by the AKS module itself.
    }
  }


}
