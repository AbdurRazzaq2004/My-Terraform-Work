# ========================================
# Azure Bastion Subnet (must be named AzureBastionSubnet)
# ========================================
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

# ========================================
# Bastion Public IP
# ========================================
resource "azurerm_public_ip" "bastion_pip" {
  name                = "${var.prefix}-bastion-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

# ========================================
# Azure Bastion Host
# ========================================
resource "azurerm_bastion_host" "bastion" {
  name                = "${var.prefix}-bastion"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
