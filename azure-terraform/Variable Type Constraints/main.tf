# ========================================
# Resource Group
# ========================================
resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"           # String interpolation using var.environment
  location = var.allowed_locations[2]                  # Accessing list element by index (East US)
}

# ========================================
# Virtual Network
# ========================================
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = [element(var.network_config, 0)]   # Tuple element 0: VNET address space
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# ========================================
# Subnet
# ========================================
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["${element(var.network_config, 1)}/${element(var.network_config, 2)}"]  # Tuple elements 1 and 2: subnet address/mask
}

# ========================================
# Network Interface
# ========================================
resource "azurerm_network_interface" "main" {
  name                = "${var.environment}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# ========================================
# Virtual Machine
# ========================================
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.environment}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.allowed_vm_sizes[0]              # List element 0: Standard_DS1_v2

  # Delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = var.is_delete                # Boolean variable

  # Delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.vm_config.publisher                         # Object attribute
    offer     = var.vm_config.offer                             # Object attribute
    sku       = var.vm_config.sku                               # Object attribute
    version   = var.vm_config.version                           # Object attribute
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.storage_disk                        # Number variable
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = var.resource_tags["environment"]              # Map access by key
    managed_by  = var.resource_tags["managed_by"]               # Map access by key
    department  = var.resource_tags["department"]                # Map access by key
  }
}
