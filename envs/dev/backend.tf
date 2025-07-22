terraform {
  backend "azurerm" {
    resource_group_name  = "tf-store-rg"
    storage_account_name = "satflabstore"
    container_name       = "satflabstoreblob001"
    key                  = "terraform.tfstate"
  }
}


