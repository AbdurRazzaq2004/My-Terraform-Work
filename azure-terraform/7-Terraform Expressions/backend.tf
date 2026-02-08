terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-backend"                  # Resource group for the backend storage
    storage_account_name = "tfbackendrazzaq2026"              # Replace with your actual storage account name
    container_name       = "tfstate-backend"                  # Blob container name
    key                  = "expressions.terraform.tfstate"    # Name of the state file blob
  }
}
