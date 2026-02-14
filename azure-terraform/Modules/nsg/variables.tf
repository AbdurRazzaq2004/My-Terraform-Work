# Azure Network Security Group Module

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "security_rules" {
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = optional(string, "*")
    destination_port_range     = string
    source_address_prefix      = optional(string, "*")
    destination_address_prefix = optional(string, "*")
  }))
  default = {}
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to associate with the NSG"
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
