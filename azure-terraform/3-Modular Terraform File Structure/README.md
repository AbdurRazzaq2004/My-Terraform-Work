# Modular Terraform File Structure

## Overview

This project demonstrates the **modular file structure** approach in Terraform. Instead of writing everything inside a single `main.tf` file, we split the configuration into separate, purpose specific files. This makes the code easier to read, maintain, and collaborate on.

---

## Why Use a Modular File Structure?

When your Terraform project grows, having everything in one file becomes messy and hard to manage. By splitting the code into multiple files, each file has a single responsibility.

| Benefit                  | Description                                                                 |
|:-------------------------|:----------------------------------------------------------------------------|
| **Readability**          | Each file is focused on one thing, making it easier to understand           |
| **Maintainability**      | Changes to one resource do not affect unrelated code                        |
| **Collaboration**        | Multiple team members can work on different files without merge conflicts   |
| **Reusability**          | Variables and outputs make configurations easy to reuse across environments |
| **Best Practice**        | This is the industry standard way of organizing Terraform projects          |

---

## File Structure

```
Modular Terraform File Structure/
│
├── provider.tf          # Terraform and provider configuration
├── backend.tf           # Remote backend configuration (Azure Blob Storage)
├── variables.tf         # Input variable declarations
├── terraform.tfvars     # Variable values for the current environment
├── local.tf             # Local values (computed variables and tags)
├── resource-group.tf    # Azure Resource Group resource
├── storage-account.tf   # Azure Storage Account resource
├── output.tf            # Output values displayed after apply
├── .gitignore           # Files to exclude from version control
└── README.md            # Documentation (this file)
```

---

## What Each File Does

### 1. `provider.tf`

This file contains the **Terraform block** and **provider configuration**. It declares which provider to use (AzureRM), the required versions, and the provider settings.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  subscription_id                 = "your_subscription_id"
  resource_provider_registrations = "none"
  features {}
}
```

### 2. `backend.tf`

This file configures the **remote backend** to store the Terraform state file in Azure Blob Storage instead of your local machine.

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-backend"
    storage_account_name = "tfbackendrazzaq2026"
    container_name       = "tfstate-backend"
    key                  = "dev.terraform.tfstate"
  }
}
```

### 3. `variables.tf`

This file declares **input variables** that make the configuration dynamic and reusable. Instead of hardcoding values, we use variables so the same code can be used for different environments.

```hcl
variable "environment" {
  type        = string
  description = "The environment type (e.g., dev, staging, prod)"
  default     = "staging"
}
```

### 4. `terraform.tfvars`

This file contains the **actual values** for the variables declared in `variables.tf`. Terraform automatically loads this file when you run `plan` or `apply`.

```hcl
environment          = "staging"
resource_group_name  = "example-resources"
location             = "West Europe"
storage_account_name = "mystorageaccountexample1"
```

### 5. `local.tf`

This file defines **local values** which are like computed variables. They are useful for creating reusable values like tags that are shared across multiple resources.

```hcl
locals {
  common_tags = {
    environment = var.environment
    lob         = "banking"
    stage       = "alpha"
  }
}
```

### 6. `resource-group.tf`

This file contains the **Azure Resource Group** resource. It uses variables for the name and location instead of hardcoded values.

```hcl
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}
```

### 7. `storage-account.tf`

This file contains the **Azure Storage Account** resource. It references the resource group using implicit dependency and uses `local.common_tags` for tags.

```hcl
resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.common_tags
}
```

### 8. `output.tf`

This file defines **output values** that are displayed after `terraform apply` completes. Outputs are useful for viewing important information about the created resources.

```hcl
output "storage_account_name" {
  value       = azurerm_storage_account.example.name
  description = "The name of the created Storage Account"
}
```

---

## Key Concepts

### Variables (`var.`)

Variables allow you to parameterize your Terraform configuration. Instead of hardcoding values like `"West Europe"`, you use `var.location` which reads the value from `variables.tf` or `terraform.tfvars`.

### Locals (`local.`)

Locals are like internal computed variables. They are defined once and can be reused across multiple resources. In this project, `local.common_tags` defines a set of tags that are applied to all resources.

### Outputs

Outputs display useful information after Terraform creates the resources. For example, the storage account name and its primary endpoint are shown in the terminal output.

---

## Before vs After: Single File vs Modular Structure

| Aspect            | Single File (`main.tf`)                      | Modular Structure (Multiple Files)            |
|:------------------|:---------------------------------------------|:----------------------------------------------|
| All code in       | One large file                               | Separate purpose specific files               |
| Readability       | ❌ Hard to navigate as project grows          | ✅ Each file is small and focused              |
| Hardcoded values  | ❌ Values written directly in resources       | ✅ Values come from variables and tfvars       |
| Tags management   | ❌ Repeated in every resource                 | ✅ Defined once in locals, reused everywhere   |
| Team work         | ❌ Merge conflicts on a single file           | ✅ Each person works on different files         |

---

## How to Use

1. Update `provider.tf` with your Azure `subscription_id`.
2. Update `backend.tf` with your remote backend storage details.
3. Update `terraform.tfvars` with the values for your environment.
4. Run the following commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
5. To see only the resources that will be created:
   ```bash
   terraform plan | grep "will be created"
   ```
6. To destroy all resources:
   ```bash
   terraform destroy
   ```

---

## Prerequisites

1. **Terraform** version 1.9.0 or later
2. **Azure CLI** installed and authenticated (`az login`)
3. An active **Azure Subscription**
4. Remote backend storage already created (see the **StateFile Management with Azure Storage** guide)

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform Configuration Files](https://developer.hashicorp.com/terraform/language/files)
- [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Terraform Local Values](https://developer.hashicorp.com/terraform/language/values/locals)
- [Terraform Output Values](https://developer.hashicorp.com/terraform/language/values/outputs)
- [Terraform Override Files](https://developer.hashicorp.com/terraform/language/files/override)
- [Terraform Variable Definitions (.tfvars)](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Microsoft Azure Documentation
- [Azure Resource Groups Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups)
- [Azure Storage Account Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Terraform on Azure Best Practices](https://learn.microsoft.com/en-us/azure/developer/terraform/best-practices-terraform-azure)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

### Course Reference
- [Day 06 Terraform Course](https://github.com/piyushsachdeva/Terraform-Full-Course-Azure/tree/main/lessons/day06)
