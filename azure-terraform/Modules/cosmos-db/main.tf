# Azure Cosmos DB Module

resource "azurerm_cosmosdb_account" "this" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type
  kind                = var.kind
  free_tier_enabled   = var.enable_free_tier
  tags                = var.tags

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  dynamic "geo_location" {
    for_each = var.failover_location != null ? [var.failover_location] : []
    content {
      location          = geo_location.value
      failover_priority = 1
    }
  }
}

resource "azurerm_cosmosdb_sql_database" "this" {
  count               = var.database_name != null && var.kind == "GlobalDocumentDB" ? 1 : 0
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.database_throughput
}
