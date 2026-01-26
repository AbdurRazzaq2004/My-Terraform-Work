output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Map of AZ to private route table IDs"
  value       = { for k, rt in aws_route_table.private : k => rt.id }
}

output "nat_gateway_ids" {
  description = "Map of AZ to NAT Gateway IDs"
  value       = { for k, nat in aws_nat_gateway.this : k => nat.id }
}

output "nat_eip_ids" {
  description = "Map of AZ to NAT EIP IDs"
  value       = { for k, eip in aws_eip.nat : k => eip.id }
}

output "nat_public_ips" {
  description = "Map of AZ to NAT Gateway public IPs"
  value       = { for k, eip in aws_eip.nat : k => eip.public_ip }
}
