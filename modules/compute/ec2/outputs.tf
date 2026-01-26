output "instance_ids" {
  description = "Map of instance names to their IDs"
  value       = { for k, i in aws_instance.this : k => i.id }
}

output "private_ips" {
  description = "Map of instance names to their private IPs"
  value       = { for k, i in aws_instance.this : k => i.private_ip }
}

output "public_ips" {
  description = "Map of instance names to their public IPs (if assigned)"
  value       = { for k, i in aws_instance.this : k => i.public_ip if i.public_ip != null }
}

output "eip_public_ips" {
  description = "Map of instance names to their Elastic IP addresses"
  value       = { for k, eip in aws_eip.this : k => eip.public_ip }
}

output "instances" {
  description = "Full instance objects with all attributes"
  value       = aws_instance.this
}
