variable "name" {
  description = "The name of the Resource Group."
  type        = string
}

variable "location" {
  description = "The Azure region where the Resource Group should exist."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the Resource Group."
  type        = map(string)
  default     = {}
}