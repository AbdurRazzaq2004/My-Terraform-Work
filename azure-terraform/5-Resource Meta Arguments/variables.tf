# String Type
variable "environment" {
  type        = string
  description = "The environment type (e.g., dev, staging, prod)"
  default     = "staging"
}

# Number Type
variable "storage_disk" {
  type        = number
  description = "The storage disk size of the OS in GB"
  default     = 80
}

# Boolean Type
variable "is_delete" {
  type        = bool
  description = "The default behavior to delete the OS disk upon VM termination"
  default     = true
}

# List Type
variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Azure locations"
  default     = ["West Europe", "North Europe", "East US"]
}

variable "allowed_vm_sizes" {
  type        = list(string)
  description = "Allowed VM sizes"
  default     = ["Standard_DS1_v2", "Standard_DS2_v2", "Standard_DS3_v2"]
}

# Set Type (used with for_each)
variable "storage_account_name" {
  type        = set(string)
  description = "Set of storage account names to create using for_each"
  default     = ["techtutorials11", "techtutorials12"]
}

# Map Type
variable "resource_tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default = {
    "environment" = "staging"
    "managed_by"  = "terraform"
    "department"  = "devops"
  }
}

# Tuple Type
variable "network_config" {
  type        = tuple([string, string, number])
  description = "Network configuration (VNET address, subnet address, subnet mask)"
  default     = ["10.0.0.0/16", "10.0.2.0", 24]
}

# Object Type
variable "vm_config" {
  type = object({
    size      = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Virtual machine configuration"
  default = {
    size      = "Standard_DS1_v2"
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
