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
  subscription_id                 = "80ea84e8-afce-4851-928a-9e2219724c69" # Replace with your subscription ID
  resource_provider_registrations = "none"
  features {}
}
