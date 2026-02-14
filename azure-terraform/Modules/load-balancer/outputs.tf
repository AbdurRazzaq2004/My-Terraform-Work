output "lb_id" {
  description = "ID of the Load Balancer"
  value       = azurerm_lb.this.id
}

output "public_ip_address" {
  description = "Public IP address of the LB"
  value       = azurerm_public_ip.this.ip_address
}

output "backend_pool_id" {
  description = "ID of the backend address pool"
  value       = azurerm_lb_backend_address_pool.this.id
}

output "frontend_ip_configuration_id" {
  description = "ID of the frontend IP configuration"
  value       = azurerm_lb.this.frontend_ip_configuration[0].id
}
