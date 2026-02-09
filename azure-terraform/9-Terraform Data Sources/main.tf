# ========================================
# DATA SOURCES
# ========================================
# Data sources READ existing resources that were
# created outside of this Terraform configuration.
# They do NOT create, update, or delete anything.

# Read an existing Resource Group
data "azurerm_resource_group" "rg_shared" {
  name = var.shared_rg_name
}

# Read an existing Virtual Network from the shared resource group
data "azurerm_virtual_network" "vnet_shared" {
  name                = var.shared_vnet_name
  resource_group_name = data.azurerm_resource_group.rg_shared.name
}

# Read an existing Subnet from the shared virtual network
data "azurerm_subnet" "subnet_shared" {
  name                 = var.shared_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg_shared.name
  virtual_network_name = data.azurerm_virtual_network.vnet_shared.name
}

# ========================================
# RESOURCES (using data from data sources)
# ========================================

# Create a NEW resource group
# Uses the LOCATION from the shared resource group (data source)
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = data.azurerm_resource_group.rg_shared.location
}

# Create a Network Interface
# Uses the SUBNET ID from the shared subnet (data source)
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet_shared.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a Virtual Machine
# Uses the NIC created above, which connects to the shared subnet
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = local.common_tags
}
