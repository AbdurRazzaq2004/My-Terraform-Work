terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
    subscription_id                 = "80ea84e8-afce-4851-928a-9e2219724c69"
    resource_provider_registrations = "none"
    features {
      
    }
  
}

resource "azurerm_resource_group" "resource-group-example1" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {

#depends_on = [ azurerm_resource_group.example ] --> explicit dependency

  name                     = "mystorageaccountexample1"
  resource_group_name      = azurerm_resource_group.resource-group-example1.name
  location                 = azurerm_resource_group.resource-group-example1.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}
