terraform {
  backend "azurerm" {
    resource_group_name  = "<your-rg-name>"
    storage_account_name = "<your-storage-account>"
    container_name       = "tfstate-backend"
    key                  = "intermediate-project1.terraform.tfstate"
  }
}
