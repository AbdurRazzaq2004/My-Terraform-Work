terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  subscription_id                 = "9734ed68-621d-47ed-babd-269110dbacb1" # Replace with your subscription ID
  resource_provider_registrations = "none"
  features {}
}
