# AWS SQS Module

variable "queue_name" {
  type = string
}

variable "delay_seconds" {
  type    = number
  default = 0
}

variable "max_message_size" {
  type    = number
  default = 262144
}

variable "message_retention_seconds" {
  type    = number
  default = 345600
}

variable "visibility_timeout_seconds" {
  type    = number
  default = 30
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "Long polling wait time (0 for short polling)"
  default     = 10
}

variable "enable_dlq" {
  type        = bool
  description = "Create a Dead Letter Queue"
  default     = true
}

variable "max_receive_count" {
  type        = number
  description = "Number of receives before moving to DLQ"
  default     = 5
}

variable "tags" {
  type    = map(string)
  default = {}
}
