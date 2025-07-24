variable "azure_tenant_id" {
  description = "The Azure Tenant ID for Service Principal authentication."
  type        = string
}

variable "sql_mi_admin_password" {
  description = "The administrator login password for the SQL Managed Instance."
  type        = string
  sensitive   = true
}