# ========================================
# Assignment 1: Formatted Project Name
# ========================================
output "formatted_project_name" {
  description = "Project name after lower() and replace()"
  value       = local.formatted_name
}

# ========================================
# Resource Outputs
# ========================================
output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  description = "The formatted storage account name"
  value       = azurerm_storage_account.example.name
}

output "nsg_name" {
  description = "The name of the Network Security Group"
  value       = azurerm_network_security_group.example.name
}

# ========================================
# Assignment 4: NSG Rules
# ========================================
output "nsg_rules" {
  description = "All NSG rules generated from split() and for expression"
  value       = local.nsg_rules
}

# ========================================
# Assignment 5: VM Size Lookup
# ========================================
output "vm_size" {
  description = "VM size resolved from lookup() based on environment"
  value       = local.vm_size
}

# ========================================
# Assignment 7: Backup and Credential
# ========================================
output "backup_name" {
  description = "Validated backup name"
  value       = var.backup_name
}

output "credential" {
  description = "Sensitive credential output"
  value       = var.credential
  sensitive   = true
}

# ========================================
# Assignment 9: Unique Locations
# ========================================
output "unique_locations" {
  description = "Unique locations after toset() and concat()"
  value       = local.unique_location
}

# ========================================
# Assignment 10: Cost Calculations
# ========================================
output "positive_costs" {
  description = "All costs converted to positive using abs()"
  value       = local.positive_cost
}

output "max_cost" {
  description = "Maximum cost found using max()"
  value       = local.max_cost
}

# ========================================
# Assignment 11: Timestamps
# ========================================
output "resource_date" {
  description = "Date formatted for resource names (YYYYMMDD)"
  value       = local.resource_name
}

output "tag_date" {
  description = "Date formatted for tags (DD-MM-YYYY)"
  value       = local.tag_date
}
