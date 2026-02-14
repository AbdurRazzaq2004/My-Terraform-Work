# AWS Auto Scaling Group Module

variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type    = string
  default = null
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "subnet_ids" {
  type = list(string)
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "health_check_type" {
  type    = string
  default = "EC2"
}

variable "health_check_grace_period" {
  type    = number
  default = 300
}

variable "target_group_arns" {
  type    = list(string)
  default = []
}

variable "user_data" {
  type    = string
  default = null
}

variable "enable_scaling_policy" {
  type    = bool
  default = true
}

variable "target_cpu_value" {
  type        = number
  description = "Target average CPU utilization for scaling"
  default     = 70
}

variable "tags" {
  type    = map(string)
  default = {}
}
