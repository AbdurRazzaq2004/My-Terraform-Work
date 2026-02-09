# ========================================
# Prefix for naming resources
# ========================================
variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "day13"
}

# ========================================
# Shared Resource Group Name
# ========================================
variable "shared_rg_name" {
  type        = string
  description = "The name of the existing shared resource group to read data from"
  default     = "shared-network-rg"
}

# ========================================
# Shared Virtual Network Name
# ========================================
variable "shared_vnet_name" {
  type        = string
  description = "The name of the existing shared virtual network"
  default     = "shared-network-vnet"
}

# ========================================
# Shared Subnet Name
# ========================================
variable "shared_subnet_name" {
  type        = string
  description = "The name of the existing shared subnet"
  default     = "shared-primary-sn"
}
