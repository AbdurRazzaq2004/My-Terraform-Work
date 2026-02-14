output "bastion_id" {
  description = "ID of the Bastion Host"
  value       = azurerm_bastion_host.this.id
}

output "bastion_fqdn" {
  description = "FQDN of the Bastion Host"
  value       = azurerm_bastion_host.this.dns_name
}

output "public_ip" {
  description = "Public IP of the Bastion"
  value       = azurerm_public_ip.bastion.ip_address
}
