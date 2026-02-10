# ========================================
# Common Tags
# ========================================
locals {
  common_tags = {
    project     = var.prefix
    environment = var.environment
    managed_by  = "terraform"
  }
}
