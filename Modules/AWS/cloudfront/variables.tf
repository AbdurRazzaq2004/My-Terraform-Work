# AWS CloudFront Module

variable "origin_domain_name" {
  type        = string
  description = "Domain name of the origin (S3 bucket or ALB)"
}

variable "origin_id" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  type    = string
  default = "redirect-to-https"
}

variable "min_ttl" {
  type    = number
  default = 0
}

variable "default_ttl" {
  type    = number
  default = 3600
}

variable "max_ttl" {
  type    = number
  default = 86400
}

variable "acm_certificate_arn" {
  type    = string
  default = null
}

variable "aliases" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
