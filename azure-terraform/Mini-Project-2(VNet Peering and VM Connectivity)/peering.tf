# ========================================
# VNet Peering (VNet1 → VNet2)
# ========================================
resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  count = var.enable_peering ? 1 : 0

  name                      = "${var.prefix}-peer1to2"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# ========================================
# VNet Peering (VNet2 → VNet1)
# ========================================
resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  count = var.enable_peering ? 1 : 0

  name                      = "${var.prefix}-peer2to1"
  resource_group_name       = data.azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}
