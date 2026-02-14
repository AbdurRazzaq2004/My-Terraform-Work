# AWS Lambda Module

variable "function_name" {
  type = string
}

variable "runtime" {
  type    = string
  default = "python3.12"
}

variable "handler" {
  type    = string
  default = "lambda_function.lambda_handler"
}

variable "source_path" {
  type        = string
  description = "Path to the Lambda deployment package (.zip)"
}

variable "timeout" {
  type    = number
  default = 30
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for VPC Lambda (leave empty for non-VPC)"
  default     = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "policy_arns" {
  type        = list(string)
  description = "Additional IAM policy ARNs to attach"
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
