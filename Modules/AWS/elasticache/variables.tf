# AWS ElastiCache Module

variable "cluster_name" {
  type = string
}

variable "engine" {
  type    = string
  default = "redis"
}

variable "engine_version" {
  type    = string
  default = "7.0"
}

variable "node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "num_cache_nodes" {
  type    = number
  default = 1
}

variable "port" {
  type    = number
  default = 6379
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "parameter_group_name" {
  type    = string
  default = null
}

variable "snapshot_retention_limit" {
  type    = number
  default = 0
}

variable "tags" {
  type    = map(string)
  default = {}
}
