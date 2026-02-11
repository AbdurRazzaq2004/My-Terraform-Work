# String Type
variable "environment" {
  type        = string
  description = "The environment type (e.g., dev, staging, prod)"
  default     = "prod"
}

# String Type (Location)
variable "location" {
  type        = string
  description = "The Azure region where resources will be created"
  default     = "West Europe"
}

# List Type
variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Azure locations for precondition validation"
  default     = ["West Europe", "North Europe", "East US"]
}

# Set Type (used with for_each)
variable "storage_account_name" {
  type        = set(string)
  description = "Set of storage account names to create using for_each"
  default     = ["techtutorials11", "techtutorials12"]
}
