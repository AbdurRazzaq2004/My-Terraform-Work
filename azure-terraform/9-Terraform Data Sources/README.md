# Terraform Data Sources

This folder demonstrates **Terraform Data Sources**, which allow you to **read information from existing resources** that were created outside of your current Terraform configuration. This is based on **Day 13** of the Terraform course.

---

## 📁 File Structure

| File | Description |
|------|-------------|
| `provider.tf` | Configures the AzureRM provider with subscription ID and feature block |
| `backend.tf` | Configures remote state storage in Azure Blob Storage |
| `variables.tf` | Defines variables for shared resource names (RG, VNET, Subnet) |
| `local.tf` | Defines common tags for resources |
| `main.tf` | Contains data sources and resources that use data from those sources |
| `output.tf` | Displays attributes read from data sources and created resources |
| `.gitignore` | Excludes Terraform cache and state files from version control |

---

## 🧠 What Is a Data Source?

A **data source** in Terraform allows you to **read** (query) information about resources that **already exist** in your infrastructure. Unlike `resource` blocks that **create** new resources, `data` blocks only **fetch** information.

Think of it this way:

| Block | Keyword | Action | Example |
|-------|---------|--------|---------|
| `resource` | `resource` | **Creates** a new resource | Create a new resource group |
| `data` | `data` | **Reads** an existing resource | Read an existing resource group that was created manually or by another team |

### Syntax

```hcl
data "<provider>_<resource_type>" "<local_name>" {
  # Arguments to identify the existing resource
  name = "existing-resource-name"
}
```

### How to Reference

```hcl
# Reference pattern: data.<provider_resource_type>.<local_name>.<attribute>
data.azurerm_resource_group.rg_shared.name
data.azurerm_resource_group.rg_shared.location
data.azurerm_resource_group.rg_shared.id
```

---

## ❓ Why Do We Use Data Sources?

### Problem

Imagine this scenario in a real company:

- **Team A** (Network Team) creates shared infrastructure: resource groups, virtual networks, subnets, and NSGs
- **Team B** (Application Team) needs to deploy VMs into the **same network** that Team A created
- Team B does **NOT** own or manage the network resources
- Team B should **NOT** recreate the network resources in their Terraform code

### Solution

Data sources allow Team B to **reference** Team A's existing resources without managing them:

```
Team A (manages)  →  Shared VNET, Subnets, NSGs
                          ↑
Team B (reads)    →  data "azurerm_virtual_network" (reads the VNET info)
                     resource "azurerm_virtual_machine" (creates VM in the shared VNET)
```

### Real World Reasons to Use Data Sources

| # | Reason | Example |
|---|--------|---------|
| 1 | **Read shared infrastructure** | Read a VNET created by another team to deploy your VM into it |
| 2 | **Read resources from another state** | Read outputs from a different Terraform project |
| 3 | **Read manually created resources** | Reference a resource group created through the Azure Portal |
| 4 | **Get dynamic information** | Fetch the latest VM image, current subscription ID, or available regions |
| 5 | **Avoid hardcoding** | Instead of hardcoding a subnet ID, read it dynamically |
| 6 | **Cross team collaboration** | Multiple teams share the same infrastructure without conflicts |

---

## ❓ When Do We Use Data Sources?

| Situation | Use Resource? | Use Data Source? |
|-----------|:---:|:---:|
| You need to **create** a new resource group | ✅ | ❌ |
| You need to **read** an existing resource group | ❌ | ✅ |
| You need to deploy a VM into a VNET **you own** | ✅ | ❌ |
| You need to deploy a VM into a VNET **another team owns** | ❌ | ✅ |
| You need the **current Azure subscription ID** | ❌ | ✅ |
| You need the **latest Ubuntu image** for a VM | ❌ | ✅ |
| A resource was created **manually in the Azure Portal** | ❌ | ✅ |
| A resource was created by **another Terraform project** | ❌ | ✅ |

### Rule of Thumb

> If you **own and manage** the resource → use `resource`
> If you **only need to read** the resource → use `data`

---

## 🔧 How We Used Data Sources in This Project

### The Scenario

A shared network team has already created:
- A **resource group** called `shared-network-rg`
- A **virtual network** called `shared-network-vnet`
- A **subnet** called `shared-primary-sn`

Our job is to deploy a VM into this **existing** network without recreating any of it.

### Step 1: Read the Existing Resources (Data Sources)

```hcl
# Read the shared resource group
data "azurerm_resource_group" "rg_shared" {
  name = "shared-network-rg"
}

# Read the shared virtual network
data "azurerm_virtual_network" "vnet_shared" {
  name                = "shared-network-vnet"
  resource_group_name = data.azurerm_resource_group.rg_shared.name
}

# Read the shared subnet
data "azurerm_subnet" "subnet_shared" {
  name                 = "shared-primary-sn"
  resource_group_name  = data.azurerm_resource_group.rg_shared.name
  virtual_network_name = data.azurerm_virtual_network.vnet_shared.name
}
```

### Step 2: Use Data Source Values in New Resources

```hcl
# Create a new resource group using the SAME LOCATION as the shared one
resource "azurerm_resource_group" "example" {
  name     = "day13-rg"
  location = data.azurerm_resource_group.rg_shared.location    # ← from data source
}

# Create a NIC and connect it to the SHARED SUBNET
resource "azurerm_network_interface" "main" {
  name                = "day13-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet_shared.id    # ← from data source
    private_ip_address_allocation = "Dynamic"
  }
}
```

### What Happens During terraform plan

```
data.azurerm_resource_group.rg_shared: Reading...
data.azurerm_resource_group.rg_shared: Read complete (ID: /subscriptions/.../shared-network-rg)
data.azurerm_virtual_network.vnet_shared: Reading...
data.azurerm_virtual_network.vnet_shared: Read complete
data.azurerm_subnet.subnet_shared: Reading...
data.azurerm_subnet.subnet_shared: Read complete

Plan: 3 to add, 0 to change, 0 to destroy.
```

Notice that data sources show **"Reading..."** not "Creating...". They only fetch information.

---

## 🔄 Data Source vs Resource Comparison

| Feature | `resource` Block | `data` Block |
|---------|-----------------|-------------|
| **Keyword** | `resource` | `data` |
| **Action** | Creates, updates, destroys | Only reads |
| **State tracking** | Tracked in state file | Refreshed on every plan/apply |
| **Reference syntax** | `azurerm_resource_group.name.attr` | `data.azurerm_resource_group.name.attr` |
| **Ownership** | You own and manage it | Someone else owns it |
| **terraform destroy** | Destroys the resource | Nothing happens (it's not yours) |
| **If resource doesn't exist** | Creates it | **Error**: resource not found |

---

## 📋 Common Azure Data Sources

| Data Source | What It Reads | When to Use |
|-------------|--------------|-------------|
| `azurerm_resource_group` | Existing resource group | Deploy resources into a shared RG |
| `azurerm_virtual_network` | Existing VNET | Connect resources to a shared network |
| `azurerm_subnet` | Existing subnet | Place VMs or NICs in a shared subnet |
| `azurerm_subscription` | Current subscription | Get the subscription ID dynamically |
| `azurerm_client_config` | Current Azure CLI session | Get tenant ID, object ID for RBAC |
| `azurerm_key_vault` | Existing Key Vault | Read secrets for VM passwords |
| `azurerm_key_vault_secret` | Existing secret | Get passwords without hardcoding |
| `azurerm_image` | Existing VM image | Use custom images for VM creation |
| `azurerm_storage_account` | Existing storage account | Reference shared storage |
| `azurerm_network_security_group` | Existing NSG | Attach existing NSG to a new NIC |

---

## 🔗 Chaining Data Sources

Data sources can **reference each other**, just like resources. In our project, we chain three data sources:

```
data "azurerm_resource_group" ──→ provides resource_group_name
        ↓
data "azurerm_virtual_network" ──→ provides virtual_network_name
        ↓
data "azurerm_subnet" ──→ provides subnet_id
        ↓
resource "azurerm_network_interface" ──→ uses subnet_id to connect
```

Each data source uses information from the previous one:

| Data Source | Needs | Gets From |
|-------------|-------|-----------|
| `azurerm_resource_group` | `name` | Variable |
| `azurerm_virtual_network` | `name`, `resource_group_name` | Variable + RG data source |
| `azurerm_subnet` | `name`, `resource_group_name`, `virtual_network_name` | Variable + RG data source + VNET data source |

---

## ⚠️ Important Notes

### Data Sources Require the Resource to Exist

If you reference a resource that **does not exist**, Terraform will throw an error:

```
Error: Error reading Resource Group "shared-network-rg":
  Resource Group "shared-network-rg" was not found
```

This is different from a `resource` block, which would **create** it.

### Data Sources Are Read on Every Plan

Every time you run `terraform plan` or `terraform apply`, data sources are **re read**. This means:
- If the shared resource changes (e.g., new tags), your data source picks it up
- If the shared resource is deleted, your plan will **fail**

### Data Sources Don't Appear in terraform destroy

Since data sources only read information, `terraform destroy` will **not** delete the shared resources. It only destroys resources you created with `resource` blocks.

---

## 🎯 What We Did in This Project

1. **Read an existing resource group** using `data "azurerm_resource_group"` to get its name, location, and ID
2. **Read an existing virtual network** using `data "azurerm_virtual_network"` to get its address space
3. **Read an existing subnet** using `data "azurerm_subnet"` to get its ID for NIC attachment
4. **Created a new resource group** using the location from the shared resource group data source
5. **Created a network interface** connected to the shared subnet using the data source subnet ID
6. **Created a virtual machine** deployed into the shared network infrastructure
7. **Output data source attributes** to show what information was read from existing resources

---

## 🔧 Commands Used

```bash
# Initialize Terraform with backend configuration
terraform init

# Validate the configuration
terraform validate

# Preview the changes (data sources are read during this step)
terraform plan

# Apply the changes
terraform apply

# Check what will be created
terraform plan | grep "will be created"

# Destroy only the resources YOU created (data sources are untouched)
terraform destroy
```

---

## 📌 Key Takeaways

| Concept | Summary |
|---------|---------|
| Data Source | Reads information from existing resources (does not create anything) |
| Keyword | Uses `data` instead of `resource` |
| Reference Syntax | `data.<type>.<name>.<attribute>` (notice the `data.` prefix) |
| Ownership | You do NOT own or manage the resource you are reading |
| terraform destroy | Does NOT affect data source resources |
| Must Exist | The resource must already exist or Terraform throws an error |
| Refreshed Every Time | Data sources are re read on every `plan` and `apply` |
| Chaining | Data sources can reference other data sources |
| Use Case | Cross team collaboration, shared infrastructure, dynamic lookups |
| Common Data Sources | `azurerm_resource_group`, `azurerm_virtual_network`, `azurerm_subnet`, `azurerm_subscription` |

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)
- [Data Source Configuration](https://developer.hashicorp.com/terraform/language/data-sources#using-data-sources)
- [Data Source Lifecycle](https://developer.hashicorp.com/terraform/language/data-sources#data-resource-behavior)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Microsoft Azure Documentation
- [Azure Resource Groups Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups)
- [Azure Virtual Network Overview](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)
- [Azure Subnets](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet)
- [Azure Virtual Machines Overview](https://learn.microsoft.com/en-us/azure/virtual-machines/overview)
- [Azure Network Interface](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-network-interface-overview)

### Terraform AzureRM Data Source Reference
- [azurerm_resource_group (data)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)
- [azurerm_virtual_network (data)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network)
- [azurerm_subnet (data)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet)
- [azurerm_subscription (data)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription)
- [azurerm_client_config (data)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
- [azurerm_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine)
