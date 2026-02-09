terraform {
  backend "azurerm" {
    resource_group_name  = "1-e067cbe1-playground-sandbox"
    storage_account_name = "tfbackendrazzaq2026"
    container_name       = "tfstate-backend"
    key                  = "miniproject1.terraform.tfstate"
  }
}
