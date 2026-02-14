output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_fqdn" {
  description = "FQDN of the cluster"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "kube_config_raw" {
  description = "Raw kubeconfig"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kubernetes_version" {
  description = "Version of Kubernetes"
  value       = azurerm_kubernetes_cluster.this.kubernetes_version
}

output "node_resource_group" {
  description = "Auto generated node resource group"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}
