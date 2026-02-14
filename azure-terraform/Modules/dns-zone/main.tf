# Azure DNS Zone Module

# Public DNS Zone
resource "azurerm_dns_zone" "public" {
  count               = var.is_private ? 0 : 1
  name                = var.zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "private" {
  count               = var.is_private ? 1 : 0
  name                = var.zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# VNet links for private DNS zones
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = var.is_private ? var.virtual_network_links : {}
  name                  = each.key
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private[0].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = each.value.registration_enabled
  tags                  = var.tags
}

# A Records for public zones
resource "azurerm_dns_a_record" "this" {
  for_each = {
    for k, v in var.records : k => v
    if !var.is_private && v.type == "A"
  }
  name                = each.key
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  records             = each.value.records
}

# CNAME Records for public zones
resource "azurerm_dns_cname_record" "this" {
  for_each = {
    for k, v in var.records : k => v
    if !var.is_private && v.type == "CNAME"
  }
  name                = each.key
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = var.resource_group_name
  ttl                 = each.value.ttl
  record              = each.value.records[0]
}
