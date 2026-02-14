# AWS Secrets Manager Module

variable "secret_name" {
  type = string
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "secret_string" {
  type      = string
  sensitive = true
  default   = null
}

variable "secret_map" {
  type      = map(string)
  sensitive = true
  default   = null
}

variable "recovery_window_in_days" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
