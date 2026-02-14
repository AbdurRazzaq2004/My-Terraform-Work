variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "service_principal_name" {
  type        = string
  description = "Display name of the service principal"
}

variable "client_id" {
  type        = string
  description = "Application (Client) ID of the service principal"
}

variable "client_secret" {
  type        = string
  description = "Password of the service principal"
  sensitive   = true
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version (empty string uses latest)"
  default     = ""
}

variable "vm_size" {
  type        = string
  description = "VM size for AKS nodes"
  default     = "Standard_DS2_v2"
}

variable "min_node_count" {
  type        = number
  description = "Minimum number of nodes"
  default     = 1
}

variable "max_node_count" {
  type        = number
  description = "Maximum number of nodes"
  default     = 3
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB"
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the AKS cluster"
  default     = {}
}
