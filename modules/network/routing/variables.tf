variable "name" {
  description = "Name prefix for routing resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "igw_id" {
  description = "ID of the Internet Gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "public_subnets" {
  description = "Map of public subnets with id and az"
  type = map(object({
    id = string
    az = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnets with id and az"
  type = map(object({
    id = string
    az = string
  }))
}

variable "nat_mode" {
  description = "NAT Gateway deployment mode: one_per_az (HA) or single (cost-saving)"
  type        = string
  default     = "one_per_az"

  validation {
    condition     = contains(["one_per_az", "single"], var.nat_mode)
    error_message = "nat_mode must be one_per_az or single"
  }
}

variable "create_nat" {
  description = "Whether to create NAT Gateway(s)"
  type        = bool
  default     = true
}
