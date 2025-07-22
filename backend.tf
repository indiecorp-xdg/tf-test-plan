terraform {
  backend "azurerm" {
    resource_group_name  = "tf-labs-rg"
    storage_account_name = "satflabstore"
    container_name       = "satflabstoreblob001"
    key                  = "terraform.tfstate"

    use_oidc             = true
    tenant_id            = var.azure_tenant_id # Reference the tenant ID from a variable or directly
    # client_id          = var.azure_client_id # Optional, as `azure/login` typically sets this
    # subscription_id    = var.azure_subscription_id
  }
}


variable "azure_tenant_id" {
  description = "The Azure Tenant ID for OIDC authentication."
  type        = string
}