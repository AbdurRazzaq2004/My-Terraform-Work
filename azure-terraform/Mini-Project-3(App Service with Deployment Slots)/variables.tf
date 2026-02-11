# Resource Group (pre-existing sandbox RG)
variable "resource_group_name" {
  type        = string
  description = "Name of the pre-existing resource group (sandbox lab restriction)"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
  default     = "East US"

  validation {
    condition     = contains(["East US", "West Europe", "Southeast Asia"], var.location)
    error_message = "Location must be one of: East US, West Europe, Southeast Asia"
  }
}

variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "miniproject3"
}

# App Service Configuration
variable "sku_name" {
  type        = string
  description = "The SKU name for the App Service Plan (S1, S2, S3, P1v2, P2v2, P3v2)"
  default     = "S1"

  validation {
    condition     = contains(["S1", "S2", "S3", "P1v2", "P2v2", "P3v2", "B1", "B2", "B3"], var.sku_name)
    error_message = "SKU must be a Standard, Premium, or Basic tier that supports deployment slots"
  }
}

variable "os_type" {
  type        = string
  description = "The OS type for the App Service Plan"
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be either Linux or Windows"
  }
}

variable "dotnet_version" {
  type        = string
  description = "The .NET version for the application stack"
  default     = "8.0"
}

# Source Control Configuration
variable "repo_url" {
  type        = string
  description = "GitHub repository URL for source control deployment"
  default     = "https://github.com/piyushsachdeva/tf-sample-bg"
}

variable "production_branch" {
  type        = string
  description = "Branch name for the production slot"
  default     = "master"
}

variable "staging_branch" {
  type        = string
  description = "Branch name for the staging slot"
  default     = "appServiceSlot_Working_DO_NOT_MERGE"
}

# Slot Swap Configuration
variable "swap_slot_to_production" {
  type        = bool
  description = "Whether to swap the staging slot to production (Blue/Green deployment)"
  default     = false
}
