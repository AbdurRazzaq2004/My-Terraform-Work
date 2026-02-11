output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = data.azurerm_resource_group.rg.name
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.asp.name
}

output "app_service_plan_sku" {
  description = "SKU of the App Service Plan"
  value       = azurerm_service_plan.asp.sku_name
}

output "production_url" {
  description = "URL of the production web app"
  value       = "https://${azurerm_linux_web_app.webapp.default_hostname}"
}

output "production_webapp_name" {
  description = "Name of the production web app"
  value       = azurerm_linux_web_app.webapp.name
}

output "staging_url" {
  description = "URL of the staging deployment slot"
  value       = "https://${azurerm_linux_web_app_slot.staging.default_hostname}"
}

output "staging_slot_name" {
  description = "Name of the staging slot"
  value       = azurerm_linux_web_app_slot.staging.name
}

output "slot_swapped" {
  description = "Whether the staging slot has been swapped to production"
  value       = var.swap_slot_to_production
}
