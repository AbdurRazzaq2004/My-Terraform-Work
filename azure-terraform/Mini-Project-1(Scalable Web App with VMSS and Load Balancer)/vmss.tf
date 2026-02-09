# ========================================
# NAT Gateway Public IP
# ========================================
resource "azurerm_public_ip" "natgw_pip" {
  name                = "${var.prefix}-natgw-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
  tags                = local.common_tags
}

# ========================================
# NAT Gateway (enables outbound internet for VMSS)
# ========================================
resource "azurerm_nat_gateway" "natgw" {
  name                    = "${var.prefix}-natgw"
  location                = data.azurerm_resource_group.rg.location
  resource_group_name     = data.azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
  tags                    = local.common_tags
}

# ========================================
# NAT Gateway ↔ Public IP Association
# ========================================
resource "azurerm_nat_gateway_public_ip_association" "natgw_pip_assoc" {
  public_ip_address_id = azurerm_public_ip.natgw_pip.id
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
}

# ========================================
# NAT Gateway ↔ Subnet Association
# ========================================
resource "azurerm_subnet_nat_gateway_association" "natgw_subnet_assoc" {
  subnet_id      = azurerm_subnet.app_subnet.id
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}

# ========================================
# Virtual Machine Scale Set (VMSS)
# ========================================
resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss" {
  name                        = "${var.prefix}-vmss"
  resource_group_name         = data.azurerm_resource_group.rg.name
  location                    = data.azurerm_resource_group.rg.location
  sku_name                    = local.vm_size
  instances                   = var.instance_count
  platform_fault_domain_count = 1     # Required for zonal deployments
  zones                       = ["1"]

  # User data script installs Apache and PHP on each instance
  user_data_base64 = base64encode(file("user-data.sh"))

  os_profile {
    linux_configuration {
      disable_password_authentication = true
      admin_username                  = var.admin_username

      admin_ssh_key {
        username   = var.admin_username
        public_key = file(".ssh/key.pub")
      }
    }
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-LTS-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "${var.prefix}-nic"
    primary                       = true
    enable_accelerated_networking = false

    ip_configuration {
      name                                   = "ipconfig"
      primary                                = true
      subnet_id                              = azurerm_subnet.app_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bepool.id]
    }
  }

  boot_diagnostics {
    storage_account_uri = ""
  }

  # Ignore instance count changes made by autoscaler
  lifecycle {
    ignore_changes = [instances]
  }

  tags = local.common_tags
}
