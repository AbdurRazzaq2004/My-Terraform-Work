# ========================================
# Resource Group (Assignment 1 + 2)
# ========================================
# Uses formatted name from lower() + replace()
# Uses merged tags from merge()

resource "azurerm_resource_group" "rg" {
  name     = "${local.formatted_name}-rg"
  location = "East US"
  tags     = local.merge_tags
}

# ========================================
# Storage Account (Assignment 3)
# ========================================
# Uses formatted name from substr() + lower() + replace()

resource "azurerm_storage_account" "example" {
  name                     = local.storage_formatted
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = local.merge_tags
}

# ========================================
# Network Security Group (Assignment 4)
# ========================================
# Uses dynamic block with NSG rules created from split() + for expression

resource "azurerm_network_security_group" "example" {
  name                = "${local.formatted_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = 100 + security_rule.key
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}
