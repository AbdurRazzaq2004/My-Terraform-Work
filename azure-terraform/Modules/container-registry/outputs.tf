output "acr_id" {
  description = "ID of the Container Registry"
  value       = azurerm_container_registry.this.id
}

output "login_server" {
  description = "Login server URL"
  value       = azurerm_container_registry.this.login_server
}

output "admin_username" {
  description = "Admin username"
  value       = var.admin_enabled ? azurerm_container_registry.this.admin_username : null
}

output "admin_password" {
  description = "Admin password"
  value       = var.admin_enabled ? azurerm_container_registry.this.admin_password : null
  sensitive   = true
}
