# ========================================
# Common Tags
# ========================================
locals {
  common_tags = {
    environment = var.environment
    managed_by  = "terraform"
    project     = "mini-project-1"
  }
}

# ========================================
# VM Size Lookup
# ========================================
locals {
  vm_size = lookup(var.vm_sizes, var.environment, "Standard_B1s")
}

# ========================================
# NSG Rules (for Dynamic Block)
# ========================================
locals {
  nsg_rules = {
    "allow-http" = {
      priority               = 100
      destination_port_range = "80"
      description            = "Allow HTTP traffic"
    }
    "allow-https" = {
      priority               = 101
      destination_port_range = "443"
      description            = "Allow HTTPS traffic"
    }
    "allow-ssh" = {
      priority               = 102
      destination_port_range = "22"
      description            = "Allow SSH traffic"
    }
  }
}
