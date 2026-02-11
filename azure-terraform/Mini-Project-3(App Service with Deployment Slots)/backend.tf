terraform {
  backend "azurerm" {
    resource_group_name  = "1-63a6f2d6-playground-sandbox"
    storage_account_name = "tfbackendrazzaq2026"
    container_name       = "tfstate-backend"
    key                  = "miniproject3.terraform.tfstate"
  }
}
