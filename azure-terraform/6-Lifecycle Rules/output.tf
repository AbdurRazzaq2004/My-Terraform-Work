# ========================================
# Outputs
# ========================================

# Output the resource group name
output "rgname" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.example.name
}

# Output the resource group location
output "rglocation" {
  description = "The location of the created resource group"
  value       = azurerm_resource_group.example.location
}

# Output all storage account names using a for loop
output "storage_name" {
  description = "List of all created storage account names"
  value       = [for i in azurerm_storage_account.example : i.name]
}
