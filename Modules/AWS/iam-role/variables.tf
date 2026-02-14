# AWS IAM Role Module

variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "assume_role_policy" {
  type        = string
  description = "JSON policy document for the trust relationship"
}

variable "policy_arns" {
  type        = list(string)
  description = "List of IAM policy ARNs to attach to the role"
  default     = []
}

variable "inline_policy" {
  type        = string
  description = "JSON inline policy document (optional)"
  default     = null
}

variable "max_session_duration" {
  type    = number
  default = 3600
}

variable "tags" {
  type    = map(string)
  default = {}
}
