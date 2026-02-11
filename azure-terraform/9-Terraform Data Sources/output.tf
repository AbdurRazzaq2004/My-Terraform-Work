# Data Source Outputs

# Shared resource group details (from data source)
output "shared_rg_name" {
  description = "Name of the shared resource group (read from data source)"
  value       = data.azurerm_resource_group.rg_shared.name
}

output "shared_rg_location" {
  description = "Location of the shared resource group (read from data source)"
  value       = data.azurerm_resource_group.rg_shared.location
}

output "shared_rg_id" {
  description = "ID of the shared resource group (read from data source)"
  value       = data.azurerm_resource_group.rg_shared.id
}

# Shared virtual network details (from data source)
output "shared_vnet_name" {
  description = "Name of the shared virtual network (read from data source)"
  value       = data.azurerm_virtual_network.vnet_shared.name
}

output "shared_vnet_address_space" {
  description = "Address space of the shared virtual network"
  value       = data.azurerm_virtual_network.vnet_shared.address_space
}

# Shared subnet details (from data source)
output "shared_subnet_id" {
  description = "ID of the shared subnet (used for NIC connection)"
  value       = data.azurerm_subnet.subnet_shared.id
}

output "shared_subnet_address_prefix" {
  description = "Address prefix of the shared subnet"
  value       = data.azurerm_subnet.subnet_shared.address_prefix
}

# New Resource Outputs

output "new_rg_name" {
  description = "Name of the newly created resource group"
  value       = azurerm_resource_group.example.name
}

output "vm_name" {
  description = "Name of the created virtual machine"
  value       = azurerm_virtual_machine.main.name
}

output "nic_private_ip" {
  description = "Private IP of the network interface"
  value       = azurerm_network_interface.main.private_ip_address
}
