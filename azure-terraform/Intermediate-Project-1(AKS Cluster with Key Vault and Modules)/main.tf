# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
  tags     = local.common_tags
}

# Service Principal module creates an Azure AD app and SP with password
module "service_principal" {
  source                 = "./modules/service_principal"
  service_principal_name = var.service_principal_name

  depends_on = [azurerm_resource_group.rg]
}

# Assign Contributor role to the Service Principal on the subscription
resource "azurerm_role_assignment" "sp_role" {
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = module.service_principal.service_principal_object_id

  depends_on = [module.service_principal]
}

# Key Vault module stores SP credentials securely
module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  service_principal_object_id = module.service_principal.service_principal_object_id
  service_principal_tenant_id = module.service_principal.service_principal_tenant_id
  tags                        = local.common_tags

  depends_on = [module.service_principal]
}

# Store SP client ID and secret in Key Vault
resource "azurerm_key_vault_secret" "sp_client_id" {
  name         = "sp-client-id"
  value        = module.service_principal.client_id
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [module.keyvault]
}

resource "azurerm_key_vault_secret" "sp_client_secret" {
  name         = "sp-client-secret"
  value        = module.service_principal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [module.keyvault]
}

# AKS module deploys the Kubernetes cluster using the SP credentials
module "aks" {
  source                 = "./modules/aks"
  cluster_name           = var.aks_cluster_name
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg.name
  service_principal_name = var.service_principal_name
  client_id              = module.service_principal.client_id
  client_secret          = module.service_principal.client_secret
  ssh_public_key_path    = var.ssh_public_key_path
  vm_size                = var.vm_size
  min_node_count         = var.min_node_count
  max_node_count         = var.max_node_count
  os_disk_size_gb        = var.os_disk_size_gb
  tags                   = local.common_tags

  depends_on = [module.service_principal]
}

# Save kubeconfig to a local file for kubectl access
resource "local_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig"
  content  = module.aks.kube_config

  depends_on = [module.aks]
}

# Data source to get current subscription ID
data "azurerm_subscription" "current" {}
