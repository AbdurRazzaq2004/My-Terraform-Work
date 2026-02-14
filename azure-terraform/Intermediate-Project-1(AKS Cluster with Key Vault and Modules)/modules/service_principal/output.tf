output "service_principal_name" {
  description = "Display name of the service principal"
  value       = azuread_service_principal.main.display_name
}

output "service_principal_object_id" {
  description = "Object ID of the service principal (used for role assignments)"
  value       = azuread_service_principal.main.object_id
}

output "service_principal_tenant_id" {
  description = "Tenant ID of the service principal"
  value       = azuread_service_principal.main.application_tenant_id
}

output "client_id" {
  description = "Application (Client) ID of the Azure AD application"
  value       = azuread_application.main.client_id
}

output "client_secret" {
  description = "Password for the service principal"
  value       = azuread_service_principal_password.main.value
  sensitive   = true
}
