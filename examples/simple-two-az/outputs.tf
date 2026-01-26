# ─────────────────────────────────────────────────────────────────────────────
# VPC OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc_stack.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.vpc_stack.vpc_cidr
}

# ─────────────────────────────────────────────────────────────────────────────
# SUBNET OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "public_subnet_ids" {
  description = "Map of public subnet names to their IDs"
  value       = module.vpc_stack.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Map of private subnet names to their IDs"
  value       = module.vpc_stack.private_subnet_ids
}

output "public_subnet_ids_list" {
  description = "List of public subnet IDs (for ALB, etc.)"
  value       = values(module.vpc_stack.public_subnet_ids)
}

output "private_subnet_ids_list" {
  description = "List of private subnet IDs (for ASG, etc.)"
  value       = values(module.vpc_stack.private_subnet_ids)
}

# ─────────────────────────────────────────────────────────────────────────────
# NAT GATEWAY OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "nat_gateway_ids" {
  description = "Map of AZ to NAT Gateway IDs"
  value       = module.vpc_stack.nat_gateway_ids
}

output "nat_public_ips" {
  description = "Map of AZ to NAT Gateway public IPs"
  value       = module.vpc_stack.nat_public_ips
}

# ─────────────────────────────────────────────────────────────────────────────
# SECURITY GROUP OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "security_group_ids" {
  description = "Map of security group names to their IDs"
  value       = module.vpc_stack.security_group_ids
}

output "web_sg_id" {
  description = "ID of the web security group"
  value       = module.vpc_stack.security_group_ids["web"]
}

output "app_sg_id" {
  description = "ID of the app security group"
  value       = module.vpc_stack.security_group_ids["app"]
}

output "bastion_sg_id" {
  description = "ID of the bastion security group"
  value       = module.vpc_stack.security_group_ids["bastion"]
}
