variable "environment" {
  type        = string
  description = "The environment type (e.g., dev, staging, prod)"
  default     = "staging"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group"
  default     = "example-resources"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created"
  default     = "West Europe"
}

variable "storage_account_name" {
  type        = string
  description = "The name of the Azure Storage Account"
  default     = "mystorageaccountexample1"
}
