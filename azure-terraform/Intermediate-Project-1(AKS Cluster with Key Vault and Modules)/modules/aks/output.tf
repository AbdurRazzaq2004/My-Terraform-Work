output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "kubernetes_version" {
  description = "Kubernetes version running on the cluster"
  value       = azurerm_kubernetes_cluster.aks.kubernetes_version
}

output "kube_config" {
  description = "Raw kubeconfig for kubectl access"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "node_resource_group" {
  description = "Auto created resource group for AKS nodes"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}
