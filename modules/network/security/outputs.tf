output "security_group_ids" {
  description = "Map of security group names to their IDs"
  value       = { for k, sg in aws_security_group.this : k => sg.id }
}

output "security_groups" {
  description = "Full security group objects"
  value       = aws_security_group.this
}

output "nacl_ids" {
  description = "Map of NACL names to their IDs"
  value       = { for k, nacl in aws_network_acl.this : k => nacl.id }
}
