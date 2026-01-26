# ─────────────────────────────────────────────────────────────────────────────
# GENERAL VARIABLES
# ─────────────────────────────────────────────────────────────────────────────

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "my-vpc"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "example-project"
}

# ─────────────────────────────────────────────────────────────────────────────
# VPC CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "Subnet definitions keyed by subnet name"
  type = map(object({
    cidr = string
    az   = string
    tier = string
  }))
  default = {
    public_a  = { cidr = "10.0.1.0/24", az = "us-east-1a", tier = "public" }
    public_b  = { cidr = "10.0.2.0/24", az = "us-east-1b", tier = "public" }
    private_a = { cidr = "10.0.11.0/24", az = "us-east-1a", tier = "private" }
    private_b = { cidr = "10.0.12.0/24", az = "us-east-1b", tier = "private" }
  }
}

variable "nat_mode" {
  description = "NAT Gateway mode: 'one_per_az' (HA) or 'single' (cost-saving)"
  type        = string
  default     = "single" # Use single for dev/test to save costs

  validation {
    condition     = contains(["one_per_az", "single"], var.nat_mode)
    error_message = "nat_mode must be 'one_per_az' or 'single'"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# SECURITY CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"] # IMPORTANT: Restrict this in production!
}
