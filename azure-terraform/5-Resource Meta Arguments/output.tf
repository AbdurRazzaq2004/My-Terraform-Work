# Outputs

# Using a for loop to iterate over all storage accounts
# and return their names as a list
output "storage_name" {
  description = "List of all created storage account names"
  value       = [for i in azurerm_storage_account.example : i.name]
}

# Output the resource group name
output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.example.name
}

# Output the resource group location
output "resource_group_location" {
  description = "The location of the created resource group"
  value       = azurerm_resource_group.example.location
}
