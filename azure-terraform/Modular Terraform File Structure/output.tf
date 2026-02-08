output "resource_group_name" {
  value       = azurerm_resource_group.example.name
  description = "The name of the created Resource Group"
}

output "resource_group_location" {
  value       = azurerm_resource_group.example.location
  description = "The location of the created Resource Group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.example.name
  description = "The name of the created Storage Account"
}

output "storage_account_primary_endpoint" {
  value       = azurerm_storage_account.example.primary_blob_endpoint
  description = "The primary blob endpoint of the Storage Account"
}
