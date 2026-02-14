# Azure SQL Database Module

resource "azurerm_mssql_server" "this" {
  name                         = var.server_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "this" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.this.id
  sku_name       = var.sku_name
  max_size_gb    = var.max_size_gb
  collation      = var.collation
  zone_redundant = var.zone_redundant
  tags           = var.tags
}

resource "azurerm_mssql_firewall_rule" "this" {
  for_each         = var.firewall_rules
  name             = each.key
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}
