output "app_service_id" {
  description = "ID of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.this[0].id : azurerm_windows_web_app.this[0].id
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = var.name
}

output "default_hostname" {
  description = "Default hostname of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.this[0].default_hostname : azurerm_windows_web_app.this[0].default_hostname
}

output "service_plan_id" {
  description = "ID of the service plan"
  value       = azurerm_service_plan.this.id
}

output "staging_slot_hostname" {
  description = "Hostname of the staging slot"
  value       = var.os_type == "Linux" && var.create_staging_slot ? azurerm_linux_web_app_slot.staging[0].default_hostname : null
}
