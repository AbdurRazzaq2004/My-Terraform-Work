# Outputs

# Output the resource group name
output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.rg.name
}

# Output the environment
output "environment" {
  description = "The current environment"
  value       = var.environment
}

# Splat Expression Outputs

# Output all NSG security rule names using splat expression
output "security_rule_names" {
  description = "All NSG security rule names"
  value       = azurerm_network_security_group.example.security_rule[*].name
}

# Output all NSG security rule priorities using splat expression
output "security_rule_priorities" {
  description = "All NSG security rule priorities"
  value       = azurerm_network_security_group.example.security_rule[*].priority
}

# Output all NSG source port ranges using splat expression
output "security_rule_source_ports" {
  description = "All NSG source port ranges"
  value       = azurerm_network_security_group.example.security_rule[*].source_port_range
}

# For Expression Output

# Output all rule descriptions using a for expression
output "security_rule_descriptions" {
  description = "All NSG rule descriptions using for expression"
  value       = [for rule in local.nsg_rules : rule.description]
}

# Output a specific storage account name by index
output "second_account_name" {
  description = "The second storage account name from the list"
  value       = var.account_names[1]
}
