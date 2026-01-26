variable "name" {
  description = "Name prefix for security resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "security_groups" {
  description = "Map of security groups to create"
  type = map(object({
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = optional(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = optional(string)
    }))
  }))
  default = {}
}

variable "nacls" {
  description = "Map of Network ACLs to create (optional - most teams use SGs only)"
  type = map(object({
    subnet_ids = list(string)
    ingress = list(object({
      rule_number = number
      protocol    = string
      action      = string # allow or deny
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
    egress = list(object({
      rule_number = number
      protocol    = string
      action      = string # allow or deny
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
  }))
  default = {}
}
