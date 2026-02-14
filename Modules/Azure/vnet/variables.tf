# Azure Virtual Network Module

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnets" {
  type = map(object({
    address_prefixes = list(string)
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name    = string
      service = string
      actions = list(string)
    }))
  }))
  default = {}
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
