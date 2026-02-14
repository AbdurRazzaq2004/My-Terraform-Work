# Azure App Service Module

resource "azurerm_service_plan" "this" {
  name                = "${var.name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = var.https_only
  app_settings        = var.app_settings
  tags                = var.tags

  site_config {
    always_on = var.always_on

    application_stack {
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
      python_version = var.python_version
      java_version   = var.java_version
    }
  }
}

resource "azurerm_windows_web_app" "this" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = var.https_only
  app_settings        = var.app_settings
  tags                = var.tags

  site_config {
    always_on = var.always_on

    application_stack {
      dotnet_version = var.dotnet_version
      node_version   = var.node_version
      java_version   = var.java_version
    }
  }
}

# Staging slot for Blue/Green deployment
resource "azurerm_linux_web_app_slot" "staging" {
  count          = var.os_type == "Linux" && var.create_staging_slot ? 1 : 0
  name           = "staging"
  app_service_id = azurerm_linux_web_app.this[0].id
  app_settings   = var.app_settings
  tags           = var.tags

  site_config {
    always_on = var.always_on
  }
}
