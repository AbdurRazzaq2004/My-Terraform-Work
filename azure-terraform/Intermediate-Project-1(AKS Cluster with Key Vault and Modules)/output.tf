output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

output "kubernetes_version" {
  description = "Kubernetes version running on the cluster"
  value       = module.aks.kubernetes_version
}

output "keyvault_name" {
  description = "Name of the Key Vault"
  value       = module.keyvault.keyvault_name
}

output "keyvault_id" {
  description = "ID of the Key Vault"
  value       = module.keyvault.keyvault_id
}

output "service_principal_name" {
  description = "Display name of the Service Principal"
  value       = module.service_principal.service_principal_name
}

output "client_id" {
  description = "Application (Client) ID of the Service Principal"
  value       = module.service_principal.client_id
}

output "client_secret" {
  description = "Password of the Service Principal"
  value       = module.service_principal.client_secret
  sensitive   = true
}

output "kube_config_command" {
  description = "Command to configure kubectl"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${module.aks.cluster_name}"
}
