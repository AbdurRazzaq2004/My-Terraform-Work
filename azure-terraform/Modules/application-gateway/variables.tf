# Azure Application Gateway Module

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "Standard_v2"
}

variable "sku_tier" {
  type    = string
  default = "Standard_v2"
}

variable "capacity" {
  type    = number
  default = 2
}

variable "backend_port" {
  type    = number
  default = 80
}

variable "backend_protocol" {
  type    = string
  default = "Http"
}

variable "backend_ip_addresses" {
  type    = list(string)
  default = []
}

variable "frontend_port" {
  type    = number
  default = 80
}

variable "tags" {
  type    = map(string)
  default = {}
}
