# Azure Resource Group Module

variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "East US"
}

variable "tags" {
  type    = map(string)
  default = {}
}
