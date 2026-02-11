# Outputs

output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.rg.name
}

output "vmss_name" {
  description = "Name of the Virtual Machine Scale Set"
  value       = azurerm_orchestrated_virtual_machine_scale_set.vmss.name
}

output "lb_public_ip" {
  description = "Public IP address of the Load Balancer"
  value       = azurerm_public_ip.lb_pip.ip_address
}

output "lb_domain_name" {
  description = "Fully Qualified Domain Name of the Load Balancer"
  value       = azurerm_public_ip.lb_pip.fqdn
}

output "app_url" {
  description = "URL to access the web application"
  value       = "http://${azurerm_public_ip.lb_pip.fqdn}"
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway (outbound traffic)"
  value       = azurerm_public_ip.natgw_pip.ip_address
}
