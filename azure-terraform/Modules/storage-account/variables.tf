# Azure Storage Account Module

variable "name" {
  type        = string
  description = "Storage account name (3-24 chars, lowercase alphanumeric only)"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "access_tier" {
  type    = string
  default = "Hot"
}

variable "enable_https_only" {
  type    = bool
  default = true
}

variable "min_tls_version" {
  type    = string
  default = "TLS1_2"
}

variable "enable_blob_versioning" {
  type    = bool
  default = false
}

variable "containers" {
  type = map(object({
    access_type = optional(string, "private")
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
