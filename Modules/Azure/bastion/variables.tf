# Azure Bastion Module

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "subnet_address_prefix" {
  type        = string
  description = "Address prefix for the AzureBastionSubnet"
  default     = "10.0.255.0/27"
}

variable "sku" {
  type    = string
  default = "Basic"
}

variable "tags" {
  type    = map(string)
  default = {}
}
