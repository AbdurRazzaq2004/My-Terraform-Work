# AWS S3 Bucket Module

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket (must be globally unique)"
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "enable_encryption" {
  type    = bool
  default = true
}

variable "block_public_access" {
  type    = bool
  default = true
}

variable "lifecycle_rules" {
  type = list(object({
    id                     = string
    enabled                = bool
    transition_days        = optional(number)
    transition_class       = optional(string, "STANDARD_IA")
    expiration_days        = optional(number)
    noncurrent_expiration  = optional(number, 90)
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
