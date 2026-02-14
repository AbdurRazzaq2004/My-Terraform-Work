variable "keyvault_name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "service_principal_object_id" {
  type        = string
  description = "Object ID of the service principal"
}

variable "service_principal_tenant_id" {
  type        = string
  description = "Tenant ID of the service principal"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Key Vault"
  default     = {}
}
