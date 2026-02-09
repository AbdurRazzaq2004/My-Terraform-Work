# ========================================
# Resource Group (pre-existing sandbox RG)
# ========================================
variable "resource_group_name" {
  type        = string
  description = "Name of the pre-existing resource group (sandbox lab restriction)"
}

# ========================================
# Environment
# ========================================
variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

# ========================================
# Region
# ========================================
variable "location" {
  type        = string
  description = "Azure region where resources will be created"
  default     = "East US"

  validation {
    condition     = contains(["East US", "West Europe", "Southeast Asia"], var.location)
    error_message = "Location must be one of: East US, West Europe, Southeast Asia"
  }
}

# ========================================
# Resource Name Prefix
# ========================================
variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "miniproject1"
}

# ========================================
# Network Configuration
# ========================================
variable "vnet_address_space" {
  type        = string
  description = "Address space for the Virtual Network"
  default     = "10.0.0.0/16"
}

variable "app_subnet_prefix" {
  type        = string
  description = "Address prefix for the application subnet (VMSS)"
  default     = "10.0.0.0/20"
}

variable "mgmt_subnet_prefix" {
  type        = string
  description = "Address prefix for the management subnet (future use)"
  default     = "10.0.16.0/20"
}

# ========================================
# Compute Configuration
# ========================================
variable "vm_sizes" {
  type        = map(string)
  description = "VM size mapping per environment"
  default = {
    dev     = "Standard_B1s"
    staging = "Standard_B2s"
    prod    = "Standard_B2ms"
  }
}

variable "instance_count" {
  type        = number
  description = "Default number of VMSS instances"
  default     = 3
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VMSS instances"
  default     = "azureuser"
}

# ========================================
# Autoscale Configuration
# ========================================
variable "autoscale_min" {
  type        = number
  description = "Minimum number of instances"
  default     = 2
}

variable "autoscale_max" {
  type        = number
  description = "Maximum number of instances"
  default     = 5
}

variable "scale_out_cpu_threshold" {
  type        = number
  description = "CPU percentage to trigger scale out"
  default     = 80
}

variable "scale_in_cpu_threshold" {
  type        = number
  description = "CPU percentage to trigger scale in"
  default     = 10
}
