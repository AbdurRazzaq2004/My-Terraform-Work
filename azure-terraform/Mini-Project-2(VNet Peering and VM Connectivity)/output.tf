# ========================================
# Resource Group
# ========================================
output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = data.azurerm_resource_group.rg.name
}

# ========================================
# VNet Information
# ========================================
output "vnet1_name" {
  description = "Name of VNet 1"
  value       = azurerm_virtual_network.vnet1.name
}

output "vnet1_id" {
  description = "ID of VNet 1"
  value       = azurerm_virtual_network.vnet1.id
}

output "vnet2_name" {
  description = "Name of VNet 2"
  value       = azurerm_virtual_network.vnet2.name
}

output "vnet2_id" {
  description = "ID of VNet 2"
  value       = azurerm_virtual_network.vnet2.id
}

# ========================================
# VM Private IPs
# ========================================
output "vnet1_vm_private_ips" {
  description = "Private IP addresses of VMs in VNet 1"
  value       = azurerm_network_interface.nic1[*].private_ip_address
}

output "vnet2_vm_private_ips" {
  description = "Private IP addresses of VMs in VNet 2"
  value       = azurerm_network_interface.nic2[*].private_ip_address
}

# ========================================
# Bastion
# ========================================
output "bastion_dns_name" {
  description = "DNS name of the Bastion Host"
  value       = azurerm_bastion_host.bastion.dns_name
}

# ========================================
# Peering Status
# ========================================
output "peering_enabled" {
  description = "Whether VNet peering is enabled"
  value       = var.enable_peering
}

output "peering_vnet1_to_vnet2_id" {
  description = "Peering ID from VNet 1 to VNet 2"
  value       = var.enable_peering ? azurerm_virtual_network_peering.vnet1_to_vnet2[0].id : "Not configured"
}

output "peering_vnet2_to_vnet1_id" {
  description = "Peering ID from VNet 2 to VNet 1"
  value       = var.enable_peering ? azurerm_virtual_network_peering.vnet2_to_vnet1[0].id : "Not configured"
}
