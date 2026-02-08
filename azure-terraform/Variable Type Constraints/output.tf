output "resource_group_name" {
  value       = azurerm_resource_group.example.name
  description = "The name of the created Resource Group"
}

output "resource_group_location" {
  value       = azurerm_resource_group.example.location
  description = "The location of the created Resource Group"
}

output "virtual_network_name" {
  value       = azurerm_virtual_network.main.name
  description = "The name of the created Virtual Network"
}

output "subnet_id" {
  value       = azurerm_subnet.internal.id
  description = "The ID of the created Subnet"
}

output "network_interface_id" {
  value       = azurerm_network_interface.main.id
  description = "The ID of the created Network Interface"
}

output "virtual_machine_name" {
  value       = azurerm_virtual_machine.main.name
  description = "The name of the created Virtual Machine"
}

output "vm_size" {
  value       = azurerm_virtual_machine.main.vm_size
  description = "The size of the created Virtual Machine"
}
