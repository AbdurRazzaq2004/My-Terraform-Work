# ========================================
# Random Pet Name (for unique DNS label)
# ========================================
resource "random_pet" "lb_hostname" {}

# ========================================
# Resource Group (use pre-existing sandbox RG)
# ========================================
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# ========================================
# Virtual Network
# ========================================
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}

# ========================================
# Application Subnet (for VMSS)
# ========================================
resource "azurerm_subnet" "app_subnet" {
  name                 = "${var.prefix}-app-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_subnet_prefix]
}

# ========================================
# Management Subnet (for future use)
# ========================================
resource "azurerm_subnet" "mgmt_subnet" {
  name                 = "${var.prefix}-mgmt-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.mgmt_subnet_prefix]
}

# ========================================
# Network Security Group (Dynamic Block)
# ========================================
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # Dynamic block generates security rules from local.nsg_rules map
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

  tags = local.common_tags
}

# ========================================
# NSG Association with App Subnet
# ========================================
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
