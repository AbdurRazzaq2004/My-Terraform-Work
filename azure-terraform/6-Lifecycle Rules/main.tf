# ========================================
# Resource Group with Lifecycle Rules
# ========================================
# Demonstrates: create_before_destroy, prevent_destroy,
# ignore_changes, and precondition

resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.location

  tags = {
    environment = var.environment
  }

  lifecycle {
    # Creates the new resource group before destroying the old one
    create_before_destroy = true

    # Set to true to prevent accidental deletion of this resource
    # Terraform will throw an error if you try to destroy it
    prevent_destroy = false

    # Uncomment the line below to ignore manual tag changes
    # ignore_changes = [tags]

    # Custom validation: only allow specific locations
    precondition {
      condition     = contains(var.allowed_locations, var.location)
      error_message = "Please enter a valid location! Allowed locations are: ${join(", ", var.allowed_locations)}"
    }
  }
}

# ========================================
# Storage Account with Lifecycle Rules
# ========================================
# Demonstrates: create_before_destroy, ignore_changes,
# replace_triggered_by

resource "azurerm_storage_account" "example" {
  for_each = var.storage_account_name

  name                     = each.value
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = var.environment
  }

  lifecycle {
    # Creates the new storage account before destroying the old one
    # Useful when renaming a storage account to avoid downtime
    create_before_destroy = true

    # Ignores changes to account_replication_type made outside Terraform
    # If someone manually changes GRS to LRS in the portal, Terraform will not revert it
    ignore_changes = [account_replication_type]

    # Forces replacement of this storage account when the resource group ID changes
    # If the resource group is recreated, all storage accounts will also be recreated
    replace_triggered_by = [azurerm_resource_group.example.id]
  }
}
