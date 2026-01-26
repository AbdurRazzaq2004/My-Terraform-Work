# ─────────────────────────────────────────────────────────────────────────────
# SIMPLE TWO-AZ VPC EXAMPLE
# ─────────────────────────────────────────────────────────────────────────────
# This example creates a VPC with:
# - 2 public subnets (one per AZ)
# - 2 private subnets (one per AZ)
# - NAT Gateway(s) based on nat_mode
# - Basic security groups
# ─────────────────────────────────────────────────────────────────────────────

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
      Project     = var.project_name
    }
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# VPC STACK MODULE
# ─────────────────────────────────────────────────────────────────────────────

module "vpc_stack" {
  source = "../../modules/vpc_stack"

  name     = var.name
  vpc_cidr = var.vpc_cidr
  subnets  = var.subnets
  nat_mode = var.nat_mode

  # Security groups
  security_groups = {
    web = {
      description = "Security group for web servers"
      ingress = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow HTTP"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow HTTPS"
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound"
        }
      ]
    }

    bastion = {
      description = "Security group for bastion host"
      ingress = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = var.allowed_ssh_cidrs
          description = "Allow SSH from trusted IPs"
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound"
        }
      ]
    }

    app = {
      description = "Security group for application servers"
      ingress = [
        {
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          cidr_blocks = [var.vpc_cidr]
          description = "Allow app traffic from VPC"
        }
      ]
      egress = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound"
        }
      ]
    }
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
