# AWS EC2 Instance Module

variable "instance_name" {
  type        = string
  description = "Name of the EC2 instance"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the instance"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the instance in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs"
  default     = []
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
  default     = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "associate_public_ip" {
  type    = bool
  default = false
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
