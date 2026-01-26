variable "name" {
  description = "Name prefix for EC2 resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "instances" {
  description = "Map of EC2 instances to create"
  type = map(object({
    ami                         = string
    instance_type               = string
    subnet_id                   = string
    security_group_ids          = list(string)
    key_name                    = optional(string)
    iam_instance_profile        = optional(string)
    user_data                   = optional(string)
    user_data_replace_on_change = optional(bool, false)
    root_volume_size            = optional(number, 20)
    root_volume_type            = optional(string, "gp3")
    root_volume_encrypted       = optional(bool, true)
    detailed_monitoring         = optional(bool, false)
    require_imdsv2              = optional(bool, true)
    allocate_eip                = optional(bool, false)
  }))
  default = {}
}
