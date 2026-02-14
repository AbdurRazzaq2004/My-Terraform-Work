<div align="center">

<img src="https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
<img src="https://img.shields.io/badge/Azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure"/>

<br/><br/>

# Azure Terraform Modules

### 16 Production Ready, Reusable Modules

<br/>

<img src="https://img.shields.io/badge/Modules-16-0078D4?style=flat-square" alt="Modules"/>
<img src="https://img.shields.io/badge/Provider-AzureRM-0078D4?style=flat-square&logo=microsoftazure" alt="AzureRM"/>
<img src="https://img.shields.io/badge/Terraform-%3E%3D1.9.0-purple?style=flat-square&logo=terraform" alt="Terraform"/>

</div>

<br/>

## What Are Terraform Modules?

A **Terraform module** is a reusable, self contained package of Terraform configuration files that provisions a specific piece of infrastructure. Instead of writing the same resource blocks over and over, you write them once as a module and call that module wherever you need it.

Each module in this collection contains:

| File | Purpose |
|:---|:---|
| `variables.tf` | Input variables the module accepts |
| `main.tf` | The actual resource definitions |
| `outputs.tf` | Values the module exposes after creation |

**Benefits:**
- Write once, reuse everywhere
- Consistent infrastructure across environments
- Easier to maintain, test, and review
- Reduces code duplication

---

## Available Modules

| # | Module | Description |
|:---:|:---|:---|
| 1 | [resource-group](./resource-group/) | Resource Group |
| 2 | [vnet](./vnet/) | Virtual Network with subnets, delegations, service endpoints |
| 3 | [nsg](./nsg/) | Network Security Group with dynamic rules and subnet associations |
| 4 | [linux-vm](./linux-vm/) | Linux Virtual Machine with NIC and optional public IP |
| 5 | [storage-account](./storage-account/) | Storage Account with blob properties, versioning, containers |
| 6 | [key-vault](./key-vault/) | Key Vault with RBAC authorization and network ACLs |
| 7 | [aks](./aks/) | AKS cluster with autoscaling and system assigned identity |
| 8 | [app-service](./app-service/) | App Service (Linux/Windows) with service plan and staging slot |
| 9 | [sql-database](./sql-database/) | Azure SQL Server and database with firewall rules |
| 10 | [load-balancer](./load-balancer/) | Load Balancer with public IP, backend pool, probe, rules |
| 11 | [container-registry](./container-registry/) | Azure Container Registry |
| 12 | [bastion](./bastion/) | Bastion Host with AzureBastionSubnet and public IP |
| 13 | [application-gateway](./application-gateway/) | Application Gateway with routing rules |
| 14 | [dns-zone](./dns-zone/) | Public or Private DNS Zone with VNet links and records |
| 15 | [log-analytics](./log-analytics/) | Log Analytics Workspace |
| 16 | [cosmos-db](./cosmos-db/) | Cosmos DB account with SQL database and geo replication |

---

## How to Use a Module

### Basic Syntax

```hcl
module "<name>" {
  source = "./path/to/module"

  # pass the required variables
  variable_1 = "value"
  variable_2 = "value"
}
```

### Step by Step

**1. Reference the module** in your root `main.tf` using the `source` path.

**2. Pass the required variables** that the module expects.

**3. Use the module outputs** to connect modules together or display results.

```hcl
# Step 1 & 2: Call the module and pass variables
module "rg" {
  source = "./Modules/resource-group"

  name     = "my-resource-group"
  location = "East US"

  tags = {
    Environment = "production"
  }
}

# Step 3: Use outputs from the module
output "resource_group_name" {
  value = module.rg.name
}
```

---

## Usage Examples

### Resource Group + VNet + NSG + Linux VM

A common pattern where modules connect to each other through outputs:

```hcl
module "rg" {
  source = "./Modules/resource-group"

  name     = "app-rg"
  location = "East US"
  tags     = { Environment = "dev" }
}

module "vnet" {
  source = "./Modules/vnet"

  name                = "app-vnet"
  location            = module.rg.location
  resource_group_name = module.rg.name
  address_space       = ["10.0.0.0/16"]

  subnets = {
    web = {
      address_prefixes = ["10.0.1.0/24"]
    }
    app = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }

  tags = { Environment = "dev" }
}

module "web_nsg" {
  source = "./Modules/nsg"

  name                = "web-nsg"
  location            = module.rg.location
  resource_group_name = module.rg.name

  security_rules = {
    allow_http = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    allow_https = {
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  tags = { Environment = "dev" }
}

module "web_vm" {
  source = "./Modules/linux-vm"

  name                = "web-vm"
  location            = module.rg.location
  resource_group_name = module.rg.name
  subnet_id           = module.vnet.subnet_ids["web"]
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  ssh_public_key_path = "~/.ssh/id_rsa.pub"
  create_public_ip    = true
  tags                = { Environment = "dev" }
}
```

### Storage Account + Key Vault

```hcl
module "storage" {
  source = "./Modules/storage-account"

  name                     = "appstorage2026"
  location                 = module.rg.location
  resource_group_name      = module.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_blob_versioning   = true

  containers = {
    data   = { access_type = "private" }
    assets = { access_type = "blob" }
  }

  tags = { Environment = "production" }
}

module "kv" {
  source = "./Modules/key-vault"

  name                      = "app-keyvault-2026"
  location                  = module.rg.location
  resource_group_name       = module.rg.name
  enable_rbac_authorization = true
  purge_protection_enabled  = true
  soft_delete_retention_days = 30
  tags                      = { Environment = "production" }
}
```

### AKS + Container Registry

```hcl
module "acr" {
  source = "./Modules/container-registry"

  name                = "appcontainerreg2026"
  location            = module.rg.location
  resource_group_name = module.rg.name
  sku                 = "Standard"
  admin_enabled       = false
  tags                = { Environment = "production" }
}

module "aks" {
  source = "./Modules/aks"

  cluster_name        = "production-aks"
  location            = module.rg.location
  resource_group_name = module.rg.name
  node_vm_size        = "Standard_DS2_v2"
  node_count          = 3
  enable_auto_scaling = true
  min_count           = 2
  max_count           = 6
  network_plugin      = "azure"
  tags                = { Environment = "production" }
}
```

### App Service with Staging Slot

```hcl
module "app" {
  source = "./Modules/app-service"

  name                = "my-web-app-2026"
  location            = module.rg.location
  resource_group_name = module.rg.name
  os_type             = "Linux"
  sku_name            = "S1"
  python_version      = "3.12"
  always_on           = true
  https_only          = true
  create_staging_slot = true

  app_settings = {
    ENVIRONMENT = "production"
  }

  tags = { Environment = "production" }
}
```

### SQL Database

```hcl
module "sql" {
  source = "./Modules/sql-database"

  server_name         = "app-sql-server-2026"
  database_name       = "appdb"
  location            = module.rg.location
  resource_group_name = module.rg.name
  admin_login         = "sqladmin"
  admin_password      = "P@ssw0rd1234!"
  sku_name            = "S0"
  max_size_gb         = 10

  firewall_rules = {
    allow_azure = {
      start_ip = "0.0.0.0"
      end_ip   = "0.0.0.0"
    }
  }

  tags = { Environment = "production" }
}
```

### Load Balancer + Bastion

```hcl
module "lb" {
  source = "./Modules/load-balancer"

  name                = "app-lb"
  location            = module.rg.location
  resource_group_name = module.rg.name
  sku                 = "Standard"
  frontend_ip_name    = "frontend"
  backend_pool_name   = "backend"
  probe_port          = 80
  probe_protocol      = "Http"
  probe_path          = "/health"

  lb_rules = {
    http = {
      frontend_port = 80
      backend_port  = 80
      protocol      = "Tcp"
    }
  }

  tags = { Environment = "production" }
}

module "bastion" {
  source = "./Modules/bastion"

  name                  = "app-bastion"
  location              = module.rg.location
  resource_group_name   = module.rg.name
  virtual_network_name  = module.vnet.vnet_name
  subnet_address_prefix = "10.0.100.0/26"
  tags                  = { Environment = "production" }
}
```

### Application Gateway

```hcl
module "appgw" {
  source = "./Modules/application-gateway"

  name                 = "app-gateway"
  location             = module.rg.location
  resource_group_name  = module.rg.name
  subnet_id            = module.vnet.subnet_ids["appgw"]
  sku_name             = "Standard_v2"
  sku_tier             = "Standard_v2"
  capacity             = 2
  frontend_port        = 80
  backend_port         = 8080
  backend_protocol     = "Http"
  backend_ip_addresses = ["10.0.2.4", "10.0.2.5"]
  tags                 = { Environment = "production" }
}
```

### DNS Zone + Log Analytics + Cosmos DB

```hcl
module "dns" {
  source = "./Modules/dns-zone"

  zone_name           = "example.com"
  resource_group_name = module.rg.name
  is_private          = false

  records = {
    www = { type = "A",     ttl = 300, records = ["1.2.3.4"] }
    api = { type = "CNAME", ttl = 300, records = ["api-lb.example.com"] }
  }

  tags = { Environment = "production" }
}

module "logs" {
  source = "./Modules/log-analytics"

  name                = "app-log-analytics"
  location            = module.rg.location
  resource_group_name = module.rg.name
  retention_in_days   = 30
  tags                = { Environment = "production" }
}

module "cosmos" {
  source = "./Modules/cosmos-db"

  account_name        = "app-cosmos-2026"
  location            = module.rg.location
  resource_group_name = module.rg.name
  kind                = "GlobalDocumentDB"
  consistency_level   = "Session"
  failover_location   = "West US"
  enable_free_tier    = true
  database_name       = "appdb"
  database_throughput = 400
  tags                = { Environment = "production" }
}
```

---

## References

| Resource | Link |
|:---|:---|
| AzureRM Provider Docs | [registry.terraform.io/providers/hashicorp/azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) |
| Terraform Module Docs | [developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules) |
| Azure Documentation | [learn.microsoft.com/azure](https://learn.microsoft.com/en-us/azure/) |
