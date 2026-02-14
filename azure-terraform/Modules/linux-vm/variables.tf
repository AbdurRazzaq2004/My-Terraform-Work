# Azure Linux Virtual Machine Module

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "subnet_id" {
  type = string
}

variable "create_public_ip" {
  type    = bool
  default = false
}

variable "os_disk_size_gb" {
  type    = number
  default = 30
}

variable "os_disk_type" {
  type    = string
  default = "Standard_LRS"
}

variable "image_publisher" {
  type    = string
  default = "Canonical"
}

variable "image_offer" {
  type    = string
  default = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  type    = string
  default = "22_04-lts"
}

variable "image_version" {
  type    = string
  default = "latest"
}

variable "custom_data" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
