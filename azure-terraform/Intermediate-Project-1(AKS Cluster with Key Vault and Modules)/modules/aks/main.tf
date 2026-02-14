# Get the latest available Kubernetes version in the region
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = var.kubernetes_version != "" ? var.kubernetes_version : data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"
  tags                = var.tags

  default_node_pool {
    name                 = "defaultpool"
    vm_size              = var.vm_size
    zones                = [1, 2, 3]
    auto_scaling_enabled = true
    min_count            = var.min_node_count
    max_count            = var.max_node_count
    os_disk_size_gb      = var.os_disk_size_gb
    type                 = "VirtualMachineScaleSets"

    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }

    tags = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = trimspace(file(var.ssh_public_key_path))
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}
