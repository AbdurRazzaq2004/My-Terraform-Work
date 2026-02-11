# Reference Pre-existing Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name            = var.sku_name
  os_type             = var.os_type
  tags                = local.common_tags
}

# Production Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "${var.prefix}-webapp"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id
  tags                = merge(local.common_tags, { slot = "production" })

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }
  }
}

# Staging Deployment Slot
resource "azurerm_linux_web_app_slot" "staging" {
  name           = "staging"
  app_service_id = azurerm_linux_web_app.webapp.id
  tags           = merge(local.common_tags, { slot = "staging" })

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }
  }
}

# Source Control — Production Slot
resource "azurerm_app_service_source_control" "production_scm" {
  app_id   = azurerm_linux_web_app.webapp.id
  repo_url = var.repo_url
  branch   = var.production_branch

  depends_on = [azurerm_linux_web_app.webapp]
}

# Source Control — Staging Slot
resource "azurerm_app_service_source_control_slot" "staging_scm" {
  slot_id  = azurerm_linux_web_app_slot.staging.id
  repo_url = var.repo_url
  branch   = var.staging_branch

  depends_on = [azurerm_linux_web_app_slot.staging]
}

# Slot Swap (Blue/Green Deployment)
resource "azurerm_web_app_active_slot" "active" {
  count = var.swap_slot_to_production ? 1 : 0

  slot_id = azurerm_linux_web_app_slot.staging.id
}
