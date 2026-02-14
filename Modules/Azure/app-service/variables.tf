# Azure App Service Module

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "os_type" {
  type    = string
  default = "Linux"
}

variable "sku_name" {
  type    = string
  default = "B1"
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "dotnet_version" {
  type    = string
  default = null
}

variable "node_version" {
  type    = string
  default = null
}

variable "python_version" {
  type    = string
  default = null
}

variable "java_version" {
  type    = string
  default = null
}

variable "always_on" {
  type    = bool
  default = true
}

variable "https_only" {
  type    = bool
  default = true
}

variable "create_staging_slot" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
