# Terraform State File Management with Azure Storage

## Overview

This guide explains what the Terraform State File is, why it matters, how Terraform uses it to update infrastructure, and how to configure a **remote backend** using Azure Blob Storage to store the state file securely.

---

## Handwritten Notes

Below is a visual summary of the concepts covered in this guide:

![Terraform State File Notes](images/terraform-statefile-notes.png)

---

## What is a Terraform State File?

When you run `terraform apply`, Terraform creates a file called `terraform.tfstate`. This file is the **state file**, and it acts as a record of everything Terraform has created or manages. It maps your Terraform configuration (the `.tf` files) to the real world resources in your cloud provider.

In simple words, the state file is Terraform's memory. Without it, Terraform would not know what already exists and what needs to be created, updated, or destroyed.

---

## How Terraform Updates Infrastructure

Terraform works with two key concepts:

| Concept        | Description                                                                 |
|:---------------|:----------------------------------------------------------------------------|
| Desired State  | What you have written in your `.tf` configuration files                     |
| Actual State   | What currently exists in the cloud, recorded in the `terraform.tfstate` file |

The **goal of Terraform** is to always keep the **actual state** in sync with the **desired state**.

> **Desired State = Actual State**

### The Workflow

The complete flow looks like this:

```
User → writes .tf Files (Desired State)
                ↓
        terraform.tfstate (State File / Actual State)
                ↓
        Cloud Infrastructure (Infra)
```

1. The **User** writes or modifies Terraform configuration files (`.tf` files) which represent the **Desired State**.
2. When you run `terraform plan`, Terraform compares the **Desired State** (your code) with the **Actual State** (the `terraform.tfstate` file).
3. It generates a plan showing what changes are needed (create, update, or destroy).
4. When you run `terraform apply`, Terraform makes those changes in the cloud and updates the state file to reflect the new **Actual State**.

This cycle ensures that your infrastructure always matches what you have defined in code.

---

## Why the State File is Important

1. **Tracking Resources**: Terraform uses the state file to know which resources it manages. Without it, Terraform cannot track or update anything.
2. **Performance**: Instead of querying the cloud provider every time, Terraform reads the state file for a faster comparison.
3. **Collaboration**: When working in a team, the state file is the single source of truth for what infrastructure exists.

---

## State File Best Practices

| Practice                                       | Explanation                                                                                         |
|:-----------------------------------------------|:----------------------------------------------------------------------------------------------------|
| **Store backend file to a remote backend**     | Never keep the state file on your local machine in production. Always use a remote backend           |
| **Do not update or delete the file manually**  | Never hand edit or delete the state file. Always use `terraform state` commands if modifications are needed |
| **Enable state locking**                       | Prevents two people from running `terraform apply` at the same time and corrupting the state         |
| **Isolation of state file**                    | Use separate state files for different environments (dev, staging, prod) to avoid accidental changes across environments |
| **Regular backup**                             | Ensure regular backups of the state file. Remote backends like Azure Blob Storage handle this automatically with built in redundancy |
| **Never commit the state file to Git**         | The state file may contain sensitive information like passwords, keys, and connection strings         |

---

## What is a Remote Backend?

A **Remote Backend** is a storage location where Terraform keeps the state file instead of your local machine. When you run Terraform commands (`terraform plan`, `terraform apply`, etc.), Terraform reads from and writes to this remote location.

```
TF Commands  →  Remote Backend  →  Infra
                (State File)
```

The state file can be stored in different cloud storage services depending on your cloud provider:

| Cloud Provider       | Remote Backend Storage         |
|:---------------------|:-------------------------------|
| **AWS**              | S3 Bucket                      |
| **Azure**            | Azure Blob Storage             |
| **GCP**              | GCP Cloud Storage              |

In this project, we are using **Azure Blob Storage** as our remote backend.

---

## Setting Up a Remote Backend with Azure Blob Storage

Instead of keeping the state file on your local machine, you can store it in an **Azure Storage Account** inside a **Blob Container**. This is called a **remote backend**.

### Why Use a Remote Backend?

1. The state file is stored in a centralized, secure location.
2. Multiple team members can access the same state.
3. Azure Blob Storage supports **state locking** to prevent concurrent modifications.
4. The state file is automatically backed up and encrypted.

---

## Step by Step Setup

### Step 1: Create the Azure Resources for Backend Storage

Before configuring Terraform, you need to create the Azure resources that will hold the state file. This is done using a shell script (`create-backend-storage.sh`).

**create-backend-storage.sh**

```bash
#!/bin/bash

# ==============================================================
# Script: create-backend-storage.sh
# Purpose: Creates Azure resources needed to store the Terraform
#          state file in a remote backend (Azure Blob Storage)
# ==============================================================

RESOURCE_GROUP_NAME=tfstate-backend
STORAGE_ACCOUNT_NAME=tfstatebackendstorage
CONTAINER_NAME=tfstate-backend

# Step 1: Create a Resource Group
az group create --name $RESOURCE_GROUP_NAME --location eastus

# Step 2: Create a Storage Account with LRS replication and blob encryption
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Step 3: Create a Blob Container inside the Storage Account
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
```

**What this script does:**

| Step | Command                      | Purpose                                                                 |
|:-----|:-----------------------------|:------------------------------------------------------------------------|
| 1    | `az group create`            | Creates a Resource Group called `tfstate-backend` in the `eastus` region |
| 2    | `az storage account create`  | Creates a Storage Account with LRS replication and blob encryption      |
| 3    | `az storage container create`| Creates a Blob Container called `tfstate-backend` inside the Storage Account |

> **Note:** The storage account name must be globally unique across all of Azure, contain only lowercase letters and numbers, and be between 3 and 24 characters long.

### Step 2: Run the Script

```bash
chmod +x create-backend-storage.sh
./create-backend-storage.sh
```

After the script runs, verify the resources were created successfully.

### Step 3: Configure the Remote Backend in Terraform

In your `main.tf`, add the `backend "azurerm"` block inside the `terraform {}` block.

**main.tf**

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-backend"
    storage_account_name = "tfstatebackendstorage"              # Replace with your actual storage account name
    container_name       = "tfstate-backend"
    key                  = "dev.terraform.tfstate"   # Name of the state file blob
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
```

**Backend configuration explained:**

| Property               | Value                    | Description                                                    |
|:-----------------------|:-------------------------|:---------------------------------------------------------------|
| resource_group_name    | tfstate-backend          | The Resource Group where the Storage Account lives             |
| storage_account_name   | tfstatebackendstorage    | The Storage Account name (from the script output)              |
| container_name         | tfstate-backend          | The Blob Container that stores the state file                  |
| key                    | dev.terraform.tfstate    | The name of the blob (file) inside the container               |

> **Tip:** The `key` value lets you have multiple state files in the same container. For example, you can use `dev.terraform.tfstate` for development and `prod.terraform.tfstate` for production.

### Step 4: Initialize and Apply

```bash
terraform init
terraform plan
terraform apply
```

When you run `terraform init`, Terraform will configure the backend and store the state file in Azure Blob Storage instead of your local machine.

---

## Local State vs Remote State

| Feature                | Local State (default)                | Remote State (Azure Blob Storage)           |
|:-----------------------|:-------------------------------------|:--------------------------------------------|
| Storage Location       | Your local machine                   | Azure Storage Account                       |
| Team Collaboration     | ❌ Only one person can work at a time | ✅ Multiple team members can share the state |
| State Locking          | ❌ No locking mechanism               | ✅ Automatic locking via Azure Blob lease    |
| Security               | ❌ File sits on your laptop           | ✅ Encrypted at rest in Azure                |
| Backup                 | ❌ No automatic backup                | ✅ Azure handles redundancy and backup       |
| Risk of Data Loss      | ❌ High (local disk failure)          | ✅ Low (cloud storage)                       |

---

## File Structure

```
StateFile Management with Azure Storage/
│
├── images/
│   └── terraform-statefile-notes.png   # Handwritten notes image
├── create-backend-storage.sh           # Shell script to create Azure resources for the remote backend
├── main.tf                             # Terraform configuration with remote backend setup
└── README.md                           # Documentation (this file)
```

---

## Commands Reference

| Command                | Purpose                                                        |
|:-----------------------|:---------------------------------------------------------------|
| `az login`                            | Log in to your Azure account                                   |
| `chmod +x create-backend-storage.sh`  | Make the backend script executable                             |
| `./create-backend-storage.sh`         | Run the script to create the storage resources                 |
| `terraform init`       | Initialize Terraform and configure the remote backend          |
| `terraform plan`       | Preview the changes Terraform will make                        |
| `terraform apply`      | Apply the changes and create the resources                     |
| `terraform destroy`    | Destroy all resources managed by Terraform                     |

---

## Common Issues and How to Fix Them

### Issue 1: AuthorizationFailed when creating a Resource Group

**Error:**

```
The client 'user@example.com' does not have authorization to perform action
'Microsoft.Resources/subscriptions/resourcegroups/write' over scope
'/subscriptions/<subscription_id>/resourcegroups/tfstate-backend'
```

**Why this happens:**

Your Azure account does not have permission to create new Resource Groups. This is common in lab environments (like Pluralsight, A Cloud Guru, etc.) where your access is restricted to a pre-created resource group only.

**How to fix it:**

1. List the existing resource groups in your subscription:
   ```bash
   az group list --output table
   ```
2. Use the pre-created resource group name in both the `create-backend-storage.sh` script and the `main.tf` backend configuration instead of creating a new one.

---

### Issue 2: StorageAccountAlreadyTaken

**Error:**

```
The storage account named tfstatebackendstorage is already taken.
```

**Why this happens:**

Azure Storage Account names must be **globally unique** across all of Azure, not just within your subscription. If someone else in the world has already used that name, you cannot use it again.

**How to fix it:**

Choose a more unique storage account name. You can append random characters, your name, or a date to make it unique:

```bash
STORAGE_ACCOUNT_NAME=tfbackendrazzaq2026
```

> **Remember:** Storage account names must be all lowercase, between 3 and 24 characters, and contain only letters and numbers.

---

### Issue 3: 403 Forbidden when running `terraform init`

**Error:**

```
Error: retrieving Storage Account: unexpected status 403 (403 Forbidden)
The client does not have authorization to perform action
'Microsoft.Storage/storageAccounts/read'
```

**Why this happens:**

This error occurs when one or more of the following is true:

1. The storage account does not exist yet (you forgot to run `create-backend-storage.sh` before `terraform init`).
2. The resource group name, storage account name, or container name in `main.tf` does not match the actual Azure resources.
3. Your Azure session has expired.

**How to fix it:**

1. Make sure you have created the backend storage resources **before** running `terraform init`.
2. Verify all values in the `backend "azurerm"` block match the actual resources in Azure:
   ```bash
   az group list --output table
   az storage account list --output table
   az storage container list --account-name <your_storage_account_name> --output table
   ```
3. If your session expired, log in again:
   ```bash
   az login
   ```

---

### Issue 4: `subscription_id` is a required provider property

**Error:**

```
Error: `subscription_id` is a required provider property when performing a plan/apply operation
```

**Why this happens:**

Starting from AzureRM provider version 4.x, the `subscription_id` is mandatory in the provider block.

**How to fix it:**

Add the `subscription_id` to your provider block:

```hcl
provider "azurerm" {
  subscription_id = "<your_subscription_id>"
  features {}
}
```

Or the better approach is to set it as an environment variable:

```bash
export ARM_SUBSCRIPTION_ID="<your_subscription_id>"
```

---

### Issue 5: Terraform does not have permission to register Resource Providers

**Error:**

```
Error: Terraform does not have the necessary permissions to register Resource Providers.
```

**Why this happens:**

By default, Terraform tries to register all Azure Resource Providers it supports. In restricted environments (like lab accounts), your user may not have permission to do this.

**How to fix it:**

Add `resource_provider_registrations = "none"` to your provider block:

```hcl
provider "azurerm" {
  subscription_id                 = "<your_subscription_id>"
  resource_provider_registrations = "none"
  features {}
}
```

---

### Quick Troubleshooting Checklist

| Check | Command |
|:------|:--------|
| Verify you are logged in | `az account show` |
| List available resource groups | `az group list --output table` |
| List storage accounts | `az storage account list --output table` |
| List containers in a storage account | `az storage container list --account-name <name> --output table` |
| Check your subscription ID | `az account show --query id --output tsv` |

---

## Prerequisites

1. **Terraform** version 1.9.0 or later
2. **Azure CLI** installed and authenticated (`az login`)
3. An active **Azure Subscription**

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform State Overview](https://developer.hashicorp.com/terraform/language/state)
- [Terraform Backend Configuration](https://developer.hashicorp.com/terraform/language/backend)
- [AzureRM Backend Configuration](https://developer.hashicorp.com/terraform/language/backend/azurerm)
- [Terraform State Locking](https://developer.hashicorp.com/terraform/language/state/locking)
- [Terraform Remote State](https://developer.hashicorp.com/terraform/language/state/remote)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Microsoft Azure Documentation
- [Store Terraform State in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)
- [Azure Blob Storage Overview](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blobs-overview)
- [Azure Storage Account Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Azure CLI Storage Commands](https://learn.microsoft.com/en-us/cli/azure/storage)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
- [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
