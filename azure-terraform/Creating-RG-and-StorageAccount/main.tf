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
    features {
      
    }
  
}

resource "azurerm_resource_group" "resource-group-example1" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {

#depends_on = [ azurerm_resource_group.example ] --> explicit dependency

  name                     = "mystorageaccount-example1"
  resource_group_name      = azurerm_resource_group.resource-group-example1.name
  location                 = azurerm_resource_group.resource-group-example1.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}
