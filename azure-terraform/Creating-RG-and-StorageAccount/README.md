# Creating a Resource Group and Storage Account in Azure using Terraform

## Overview

This project demonstrates how to use Terraform to provision a **Resource Group** and a **Storage Account** on Microsoft Azure. It serves as a beginner friendly example of Infrastructure as Code (IaC) using the AzureRM provider.

## What This Configuration Does

### 1. Terraform and Provider Setup

The configuration begins by declaring the required provider and version constraints.

| Setting               | Value              |
|:----------------------|:-------------------|
| Provider              | hashicorp/azurerm  |
| Provider Version      | ~> 4.8.0          |
| Terraform Version     | >= 1.9.0           |

The `azurerm` provider is configured with an empty `features {}` block, which is mandatory for the AzureRM provider to work.

### 2. Azure Resource Group

A Resource Group is created to act as a logical container for the Azure resources.

| Property   | Value              |
|:-----------|:-------------------|
| Name       | example-resources  |
| Location   | West Europe        |

The resource is defined using `azurerm_resource_group` and is referenced internally as `resource-group-example1`.

### 3. Azure Storage Account

A Storage Account is provisioned inside the Resource Group created above.

| Property              | Value                                        |
|:----------------------|:---------------------------------------------|
| Name                  | mystorageaccount-example1                    |
| Resource Group        | Inherited from the Resource Group resource   |
| Location              | Inherited from the Resource Group resource   |
| Account Tier          | Standard                                     |
| Replication Type      | LRS (Locally Redundant Storage)              |
| Tag: environment      | dev                                          |

## Key Concepts Demonstrated

### Implicit Dependency

The Storage Account references the Resource Group's `name` and `location` using interpolation expressions like `azurerm_resource_group.resource-group-example1.name`. This creates an **implicit dependency**, meaning Terraform automatically understands that the Resource Group must be created before the Storage Account.

### Explicit Dependency (Commented Out)

The configuration also includes a commented out example of an **explicit dependency** using `depends_on`. This is useful when there is no direct reference between resources but you still want to enforce a creation order.

## How to Use

1. Make sure you have Terraform installed (version 1.9.0 or above).
2. Authenticate with Azure using `az login` or a service principal.
3. Run `terraform init` to initialize the working directory and download the provider.
4. Run `terraform plan` to preview the resources that will be created.
5. Run `terraform apply` to create the resources in your Azure subscription.
6. Run `terraform destroy` when you want to remove all the resources.

## File Structure

```
Creating-RG-and-StorageAccount/
│
├── main.tf        # Contains the provider configuration, resource group, and storage account
└── README.md      # Documentation for this project
```

## Prerequisites

1. **Terraform** version 1.9.0 or later
2. **Azure CLI** installed and authenticated
3. An active **Azure Subscription**
