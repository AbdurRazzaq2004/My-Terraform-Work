# Azure AKS Module

data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix != null ? var.dns_prefix : var.cluster_name
  kubernetes_version  = var.kubernetes_version != null ? var.kubernetes_version : data.azurerm_kubernetes_service_versions.current.latest_version
  tags                = var.tags

  default_node_pool {
    name                 = var.default_node_pool_name
    vm_size              = var.node_vm_size
    node_count           = var.enable_auto_scaling ? null : var.node_count
    auto_scaling_enabled = var.enable_auto_scaling
    min_count            = var.enable_auto_scaling ? var.min_count : null
    max_count            = var.enable_auto_scaling ? var.max_count : null
    os_disk_size_gb      = var.os_disk_size_gb
  }

  identity {
    type = var.identity_type
  }

  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = var.load_balancer_sku
  }
}
