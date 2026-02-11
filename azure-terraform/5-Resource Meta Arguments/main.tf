# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.allowed_locations[2]
}

# Storage Account using for_each
# Creates multiple storage accounts from a set variable
# Each storage account gets its own unique name from the set

resource "azurerm_storage_account" "example" {
  for_each = var.storage_account_name              # Iterates over each value in the set

  name                     = each.value             # each.value gives the current item from the set
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

# COMMENTED OUT: Storage Account using count
# This is the alternative approach using count instead of for_each
# Uncomment this block and comment the for_each block above to use count
#
# resource "azurerm_storage_account" "example" {
#   count = length(var.storage_account_name)
#
#   name                     = var.storage_account_name[count.index]
#   resource_group_name      = azurerm_resource_group.example.name
#   location                 = azurerm_resource_group.example.location
#   account_tier             = "Standard"
#   account_replication_type = "GRS"
#
#   tags = {
#     environment = "staging"
#   }
# }
