terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "1-de12b4df-playground-sandbox"
    storage_account_name = "tfbackendrazzaq2026"                      # Replace with your actual storage account name from the script output
    container_name       = "tfstate-backend"
    key                  = "dev.terraform.tfstate"
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
    subscription_id                 = "28e1e42a-4438-4c30-9a5f-7d7b488fd883"
    resource_provider_registrations = "none"
    features {
      
    }
  
}

# Using data source since this resource group already exists in the lab environment
data "azurerm_resource_group" "example" {
  name = "1-de12b4df-playground-sandbox"
}
