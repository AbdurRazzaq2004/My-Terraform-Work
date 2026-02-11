# NIC for VNet 1 VMs
resource "azurerm_network_interface" "nic1" {
  count               = var.vm_count
  name                = "${var.prefix}-vnet1-nic-${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VMs in VNet 1
resource "azurerm_linux_virtual_machine" "vm1" {
  count               = var.vm_count
  name                = "${var.prefix}-vnet1-vm-${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = var.vm_size
  admin_username      = var.admin_username
  tags                = merge(local.common_tags, { role = "vnet1-vm" })

  network_interface_ids = [
    azurerm_network_interface.nic1[count.index].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/.ssh/key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.prefix}-vnet1-osdisk-${count.index}"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# NIC for VNet 2 VMs
resource "azurerm_network_interface" "nic2" {
  count               = var.vm_count
  name                = "${var.prefix}-vnet2-nic-${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn2.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VMs in VNet 2
resource "azurerm_linux_virtual_machine" "vm2" {
  count               = var.vm_count
  name                = "${var.prefix}-vnet2-vm-${count.index}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  size                = var.vm_size
  admin_username      = var.admin_username
  tags                = merge(local.common_tags, { role = "vnet2-vm" })

  network_interface_ids = [
    azurerm_network_interface.nic2[count.index].id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/.ssh/key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.prefix}-vnet2-osdisk-${count.index}"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
