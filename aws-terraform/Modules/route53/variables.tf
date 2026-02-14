# AWS Route53 Module

variable "zone_name" {
  type        = string
  description = "Domain name for the hosted zone"
}

variable "is_private_zone" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for private hosted zone"
  default     = null
}

variable "records" {
  type = list(object({
    name    = string
    type    = string
    ttl     = optional(number, 300)
    records = optional(list(string), [])
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, true)
    }))
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
