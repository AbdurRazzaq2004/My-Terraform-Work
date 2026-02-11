# Resource Group (pre-existing sandbox RG)
variable "resource_group_name" {
  type        = string
  description = "Name of the pre-existing resource group (sandbox lab restriction)"
}

# Environment
variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

# Region
variable "location" {
  type        = string
  description = "Azure region where resources will be created"
  default     = "East US"

  validation {
    condition     = contains(["East US", "West Europe", "Southeast Asia"], var.location)
    error_message = "Location must be one of: East US, West Europe, Southeast Asia"
  }
}

# Resource Name Prefix
variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "miniproject2"
}

# Network Configuration
variable "vnet1_address_space" {
  type        = string
  description = "Address space for VNet 1"
  default     = "10.0.0.0/16"
}

variable "vnet2_address_space" {
  type        = string
  description = "Address space for VNet 2"
  default     = "10.1.0.0/16"
}

variable "subnet1_prefix" {
  type        = string
  description = "Address prefix for Subnet 1 in VNet 1"
  default     = "10.0.0.0/24"
}

variable "subnet2_prefix" {
  type        = string
  description = "Address prefix for Subnet 2 in VNet 2"
  default     = "10.1.0.0/24"
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "Address prefix for Azure Bastion Subnet in VNet 1"
  default     = "10.0.1.0/26"
}

# VM Configuration
variable "vm_count" {
  type        = number
  description = "Number of VMs to create per VNet"
  default     = 1
}

variable "vm_size" {
  type        = string
  description = "Size of the Virtual Machines"
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  type        = string
  description = "Admin username for VMs"
  default     = "azureuser"
}

# Enable/Disable Peering
variable "enable_peering" {
  type        = bool
  description = "Whether to enable VNet peering between the two VNets"
  default     = false
}
