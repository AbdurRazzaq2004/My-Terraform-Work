# ─────────────────────────────────────────────────────────────────────────────
# GENERAL
# ─────────────────────────────────────────────────────────────────────────────

variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ─────────────────────────────────────────────────────────────────────────────
# VPC
# ─────────────────────────────────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = true
}

# ─────────────────────────────────────────────────────────────────────────────
# SUBNETS
# ─────────────────────────────────────────────────────────────────────────────

variable "subnets" {
  description = "Subnet definitions keyed by subnet name"
  type = map(object({
    cidr = string
    az   = string
    tier = string # "public" or "private"
  }))
}

# ─────────────────────────────────────────────────────────────────────────────
# NAT GATEWAY
# ─────────────────────────────────────────────────────────────────────────────

variable "nat_mode" {
  description = "NAT Gateway mode: 'one_per_az' (HA) or 'single' (cost-saving)"
  type        = string
  default     = "one_per_az"

  validation {
    condition     = contains(["one_per_az", "single"], var.nat_mode)
    error_message = "nat_mode must be 'one_per_az' or 'single'"
  }
}

variable "create_nat" {
  description = "Whether to create NAT Gateway(s)"
  type        = bool
  default     = true
}

# ─────────────────────────────────────────────────────────────────────────────
# VPC FLOW LOGS (Optional)
# ─────────────────────────────────────────────────────────────────────────────

variable "enable_flow_logs" {
  description = "Whether to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_role_arn" {
  description = "IAM role ARN for VPC Flow Logs"
  type        = string
  default     = null
}

variable "flow_log_destination" {
  description = "ARN of the destination for VPC Flow Logs"
  type        = string
  default     = null
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination"
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_traffic_type" {
  description = "Type of traffic to capture"
  type        = string
  default     = "ALL"
}

# ─────────────────────────────────────────────────────────────────────────────
# SECURITY GROUPS (Optional)
# ─────────────────────────────────────────────────────────────────────────────

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

# ─────────────────────────────────────────────────────────────────────────────
# NETWORK ACLs (Optional)
# ─────────────────────────────────────────────────────────────────────────────

variable "nacls" {
  description = "Map of Network ACLs to create"
  type = map(object({
    subnet_ids = list(string)
    ingress = list(object({
      rule_number = number
      protocol    = string
      action      = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
    egress = list(object({
      rule_number = number
      protocol    = string
      action      = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
  }))
  default = {}
}

# ─────────────────────────────────────────────────────────────────────────────
# EC2 INSTANCES (Optional)
# ─────────────────────────────────────────────────────────────────────────────

variable "ec2_instances" {
  description = "Map of EC2 instances to create"
  type = map(object({
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_group_ids          = list(string)
    key_name                    = optional(string)
    iam_instance_profile        = optional(string)
    user_data                   = optional(string)
    user_data_replace_on_change = optional(bool, false)
    root_volume_size            = optional(number, 20)
    root_volume_type            = optional(string, "gp3")
    root_volume_encrypted       = optional(bool, true)
    detailed_monitoring         = optional(bool, false)
    require_imdsv2              = optional(bool, true)
    allocate_eip                = optional(bool, false)
  }))
  default = {}
}
