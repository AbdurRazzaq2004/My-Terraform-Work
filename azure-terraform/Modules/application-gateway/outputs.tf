output "app_gateway_id" {
  description = "ID of the Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "public_ip_address" {
  description = "Public IP address"
  value       = azurerm_public_ip.this.ip_address
}

output "backend_address_pool_id" {
  description = "ID of the backend pool"
  value       = tolist(azurerm_application_gateway.this.backend_address_pool)[0].id
}
