output "subnet_ids" {
  description = "Map of all subnet names to their IDs"
  value       = { for k, s in aws_subnet.this : k => s.id }
}

output "public_subnet_ids" {
  description = "Map of public subnet names to their IDs"
  value       = { for k, s in aws_subnet.this : k => s.id if var.subnets[k].tier == "public" }
}

output "private_subnet_ids" {
  description = "Map of private subnet names to their IDs"
  value       = { for k, s in aws_subnet.this : k => s.id if var.subnets[k].tier == "private" }
}

output "subnets" {
  description = "Full subnet objects with all attributes"
  value       = aws_subnet.this
}
