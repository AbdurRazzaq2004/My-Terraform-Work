# ─────────────────────────────────────────────────────────────────────────────
# VPC STACK - Wrapper module that creates a complete VPC infrastructure
# ─────────────────────────────────────────────────────────────────────────────

# ─────────────────────────────────────────────────────────────────────────────
# VPC
# ─────────────────────────────────────────────────────────────────────────────

module "vpc" {
  source = "../network/vpc"

  name     = var.name
  cidr     = var.vpc_cidr
  tags     = var.tags
  create_igw = var.create_igw

  # Flow logs configuration
  enable_flow_logs          = var.enable_flow_logs
  flow_log_role_arn         = var.flow_log_role_arn
  flow_log_destination      = var.flow_log_destination
  flow_log_destination_type = var.flow_log_destination_type
  flow_log_traffic_type     = var.flow_log_traffic_type
}

# ─────────────────────────────────────────────────────────────────────────────
# SUBNETS
# ─────────────────────────────────────────────────────────────────────────────

module "subnets" {
  source = "../network/subnets"

  name    = var.name
  vpc_id  = module.vpc.vpc_id
  subnets = var.subnets
  tags    = var.tags
}

# ─────────────────────────────────────────────────────────────────────────────
# ROUTING (NAT Gateways + Route Tables)
# ─────────────────────────────────────────────────────────────────────────────

locals {
  public_subnets = {
    for k, id in module.subnets.public_subnet_ids :
    k => { id = id, az = var.subnets[k].az }
  }

  private_subnets = {
    for k, id in module.subnets.private_subnet_ids :
    k => { id = id, az = var.subnets[k].az }
  }
}

module "routing" {
  source = "../network/routing"

  name            = var.name
  vpc_id          = module.vpc.vpc_id
  igw_id          = module.vpc.igw_id
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  nat_mode        = var.nat_mode
  create_nat      = var.create_nat
  tags            = var.tags
}

# ─────────────────────────────────────────────────────────────────────────────
# SECURITY (Security Groups + NACLs)
# ─────────────────────────────────────────────────────────────────────────────

module "security" {
  source = "../network/security"

  name            = var.name
  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
  nacls           = var.nacls
  tags            = var.tags
}

# ─────────────────────────────────────────────────────────────────────────────
# COMPUTE (EC2 Instances - Optional)
# ─────────────────────────────────────────────────────────────────────────────

module "ec2" {
  source = "../compute/ec2"

  name      = var.name
  instances = var.ec2_instances
  tags      = var.tags
}
