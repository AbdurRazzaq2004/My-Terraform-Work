variable "rgname" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "East US"
}

variable "service_principal_name" {
  type        = string
  description = "Display name for the Azure AD service principal"
}

variable "keyvault_name" {
  type        = string
  description = "Name of the Azure Key Vault (must be globally unique)"
}

variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version (leave empty to use latest)"
  default     = ""
}

variable "node_count" {
  type        = number
  description = "Initial number of nodes in the default pool"
  default     = 1
}

variable "min_node_count" {
  type        = number
  description = "Minimum number of nodes when autoscaling"
  default     = 1
}

variable "max_node_count" {
  type        = number
  description = "Maximum number of nodes when autoscaling"
  default     = 3
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes"
  default     = "Standard_DS2_v2"
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB for each node"
  default     = 30
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key for AKS Linux nodes"
  default     = "~/.ssh/id_rsa.pub"
}

variable "environment" {
  type        = string
  description = "Environment tag (dev, staging, prod)"
  default     = "dev"
}
