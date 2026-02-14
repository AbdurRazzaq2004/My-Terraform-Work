# AWS SNS Module

variable "topic_name" {
  type = string
}

variable "display_name" {
  type    = string
  default = ""
}

variable "protocol" {
  type        = string
  description = "Protocol for subscriptions (email, sms, lambda, sqs, https)"
  default     = "email"
}

variable "subscribers" {
  type        = list(string)
  description = "List of endpoints to subscribe"
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
