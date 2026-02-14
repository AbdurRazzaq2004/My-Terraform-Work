# Azure Container Registry Module

variable "name" {
  type        = string
  description = "ACR name (globally unique, alphanumeric only)"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Basic"
}

variable "admin_enabled" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
