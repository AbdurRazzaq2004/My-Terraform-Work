# Azure Cosmos DB Module

variable "account_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "offer_type" {
  type    = string
  default = "Standard"
}

variable "kind" {
  type        = string
  description = "GlobalDocumentDB, MongoDB, or Parse"
  default     = "GlobalDocumentDB"
}

variable "consistency_level" {
  type    = string
  default = "Session"
}

variable "failover_location" {
  type        = string
  description = "Secondary region for geo replication"
  default     = null
}

variable "enable_free_tier" {
  type    = bool
  default = false
}

variable "database_name" {
  type    = string
  default = null
}

variable "database_throughput" {
  type    = number
  default = 400
}

variable "tags" {
  type    = map(string)
  default = {}
}
