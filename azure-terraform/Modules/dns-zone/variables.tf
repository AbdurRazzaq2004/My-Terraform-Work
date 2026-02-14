# Azure DNS Zone Module

variable "zone_name" {
  type        = string
  description = "DNS zone name (e.g., example.com)"
}

variable "resource_group_name" {
  type = string
}

variable "is_private" {
  type    = bool
  default = false
}

variable "virtual_network_links" {
  type = map(object({
    vnet_id              = string
    registration_enabled = optional(bool, false)
  }))
  description = "VNet links for private DNS zones"
  default     = {}
}

variable "records" {
  type = map(object({
    type    = string
    ttl     = optional(number, 300)
    records = list(string)
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
