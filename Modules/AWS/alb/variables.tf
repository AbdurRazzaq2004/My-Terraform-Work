# AWS ALB Module

variable "name" {
  type        = string
  description = "Name of the ALB"
}

variable "internal" {
  type    = bool
  default = false
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "target_group_port" {
  type    = number
  default = 80
}

variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "vpc_id" {
  type = string
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_interval" {
  type    = number
  default = 30
}

variable "listener_port" {
  type    = number
  default = 80
}

variable "listener_protocol" {
  type    = string
  default = "HTTP"
}

variable "tags" {
  type    = map(string)
  default = {}
}
