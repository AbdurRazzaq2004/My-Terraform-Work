# AWS EKS Module

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the EKS cluster"
}

variable "node_group_name" {
  type    = string
  default = "default"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "node_disk_size" {
  type    = number
  default = 20
}

variable "endpoint_private_access" {
  type    = bool
  default = true
}

variable "endpoint_public_access" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
