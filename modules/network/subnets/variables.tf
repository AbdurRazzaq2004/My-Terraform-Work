variable "name" {
  description = "Name prefix for subnet resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where subnets will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "Subnet definitions keyed by subnet name"
  type = map(object({
    cidr = string
    az   = string
    tier = string # public/private
  }))

  validation {
    condition = alltrue([
      for k, v in var.subnets : contains(["public", "private"], v.tier)
    ])
    error_message = "Each subnet tier must be either 'public' or 'private'"
  }
}
