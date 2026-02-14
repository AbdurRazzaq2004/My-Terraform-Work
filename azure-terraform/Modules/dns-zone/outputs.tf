output "zone_id" {
  description = "ID of the DNS zone"
  value       = var.is_private ? azurerm_private_dns_zone.private[0].id : azurerm_dns_zone.public[0].id
}

output "zone_name" {
  description = "Name of the DNS zone"
  value       = var.zone_name
}

output "name_servers" {
  description = "Name servers (public zone only)"
  value       = var.is_private ? [] : azurerm_dns_zone.public[0].name_servers
}
