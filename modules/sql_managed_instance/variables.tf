# modules/sql_managed_instance/variables.tf

variable "sql_mi_name" {
  description = "The name of the Azure SQL Managed Instance."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the SQL MI related resources will be created."
  type        = string
}

variable "location" {
  description = "The Azure region for the SQL Managed Instance."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the dedicated subnet for the SQL Managed Instance and its Private Endpoint."
  type        = string
}

variable "vnet_id" {
  description = "The ID of the Virtual Network where the private DNS zone link will be created."
  type        = string
}

variable "license_type" {
  description = "The license type to apply for this Managed Instance."
  type        = string
  default     = "BasePrice" # Or "BasePrice" if you have Azure Hybrid Benefit
}

variable "sku_name" {
  description = "The SKU name for the SQL Managed Instance."
  type        = string
  default     = "GP_Gen5" 
}

variable "vcores" {
  description = "The number of vCores for the SQL Managed Instance."
  type        = number
  default     = 4
}

variable "storage_gb" {
  description = "The storage size in GB for the SQL Managed Instance."
  type        = number
  default     = 32
}

variable "collation" {
  description = "The collation of the SQL Managed Instance."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "administrator_login" {
  description = "The administrator login name for the SQL Managed Instance."
  type        = string
}

variable "administrator_login_password" {
  description = "The administrator login password for the SQL Managed Instance."
  type        = string
  sensitive   = true 
}

variable "tags" {
  description = "A map of tags to assign to the SQL Managed Instance resources."
  type        = map(string)
  default     = {}
}

variable "prevent_destroy" {
  type = bool
  description = "Prevent the SQL Managed Instance from being destroyed. Useful for production environments."
  default = false
}

variable "storage_account_type" {
  description = "The type of storage account to use for the SQL Managed Instance."
  type        = string
  default     = "LRS" #Possible values are GRS, GZRS, LRS, and ZRS. Defaults to GRS.
  
}