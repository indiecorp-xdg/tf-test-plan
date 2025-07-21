terraform {
  backend "azurerm" {
    resource_group_name  = "tf-labs-rg"
    storage_account_name = "satflabstore"
    container_name       = "satflabstoreblob001"
    key                  = "terraform.tfstate"
  }
}