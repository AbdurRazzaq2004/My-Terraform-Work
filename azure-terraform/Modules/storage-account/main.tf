# Azure Storage Account Module

resource "azurerm_storage_account" "this" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier
  https_traffic_only_enabled = var.enable_https_only
  min_tls_version          = var.min_tls_version
  tags                     = var.tags

  blob_properties {
    versioning_enabled = var.enable_blob_versioning
  }
}

resource "azurerm_storage_container" "this" {
  for_each              = var.containers
  name                  = each.key
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = each.value.access_type
}
