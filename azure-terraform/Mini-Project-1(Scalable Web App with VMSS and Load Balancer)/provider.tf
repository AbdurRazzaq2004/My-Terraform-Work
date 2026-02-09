terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  subscription_id                 = "2213e8b1-dbc7-4d54-8aff-b5e315df5e5b" # Replace with your subscription ID
  resource_provider_registrations = "none"
  features {}
}
