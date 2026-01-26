# ─────────────────────────────────────────────────────────────────────────────
# VPC OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "igw_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

# ─────────────────────────────────────────────────────────────────────────────
# SUBNET OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "subnet_ids" {
  description = "Map of all subnet names to their IDs"
  value       = module.subnets.subnet_ids
}

output "public_subnet_ids" {
  description = "Map of public subnet names to their IDs"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Map of private subnet names to their IDs"
  value       = module.subnets.private_subnet_ids
}

# ─────────────────────────────────────────────────────────────────────────────
# ROUTING OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.routing.public_route_table_id
}

output "private_route_table_ids" {
  description = "Map of AZ to private route table IDs"
  value       = module.routing.private_route_table_ids
}

output "nat_gateway_ids" {
  description = "Map of AZ to NAT Gateway IDs"
  value       = module.routing.nat_gateway_ids
}

output "nat_public_ips" {
  description = "Map of AZ to NAT Gateway public IPs"
  value       = module.routing.nat_public_ips
}

# ─────────────────────────────────────────────────────────────────────────────
# SECURITY OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "security_group_ids" {
  description = "Map of security group names to their IDs"
  value       = module.security.security_group_ids
}

output "nacl_ids" {
  description = "Map of NACL names to their IDs"
  value       = module.security.nacl_ids
}

# ─────────────────────────────────────────────────────────────────────────────
# EC2 OUTPUTS
# ─────────────────────────────────────────────────────────────────────────────

output "ec2_instance_ids" {
  description = "Map of EC2 instance names to their IDs"
  value       = module.ec2.instance_ids
}

output "ec2_private_ips" {
  description = "Map of EC2 instance names to their private IPs"
  value       = module.ec2.private_ips
}

output "ec2_public_ips" {
  description = "Map of EC2 instance names to their public IPs"
  value       = module.ec2.public_ips
}
