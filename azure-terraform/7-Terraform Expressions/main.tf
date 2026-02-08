# ========================================
# Resource Group
# ========================================
resource "azurerm_resource_group" "rg" {
  name     = "${var.environment}-expressions-rg"
  location = "East US"
}

# ========================================
# Network Security Group with Dynamic Block
# and Conditional Expression
# ========================================
# Conditional Expression: name changes based on the environment variable
# Dynamic Block: security rules are generated from local.nsg_rules map

resource "azurerm_network_security_group" "example" {
  name                = var.environment == "dev" ? "nsg-dev-vm" : "nsg-stage-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Dynamic block iterates over each rule in local.nsg_rules
  # and creates a security_rule block for each one
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}
