# Azure Load Balancer Module

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "frontend_ip_name" {
  type    = string
  default = "frontend"
}

variable "backend_pool_name" {
  type    = string
  default = "backend-pool"
}

variable "probe_port" {
  type    = number
  default = 80
}

variable "probe_protocol" {
  type    = string
  default = "Http"
}

variable "probe_path" {
  type    = string
  default = "/"
}

variable "lb_rules" {
  type = map(object({
    frontend_port = number
    backend_port  = number
    protocol      = optional(string, "Tcp")
  }))
  default = {
    http = {
      frontend_port = 80
      backend_port  = 80
    }
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
