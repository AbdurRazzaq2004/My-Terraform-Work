# Creating a Resource Group and Storage Account in Azure using Terraform

## Overview

This project demonstrates how to use Terraform to provision a **Resource Group** and a **Storage Account** on Microsoft Azure. It serves as a beginner friendly example of Infrastructure as Code (IaC) using the AzureRM provider.

---

## ⚠️ Important Note About Hardcoded Values in `main.tf`

In this project, the `subscription_id` is hardcoded directly inside the `main.tf` provider block. This was done **only for learning and demonstration purposes** because this project was built on a **Pluralsight Cloud Lab** environment where creating a Service Principal was not allowed due to restricted Azure Active Directory permissions.

**This is NOT a recommended practice for real world or production projects.** Hardcoding sensitive values like subscription IDs, client secrets, or tenant IDs in your Terraform files is a security risk, especially when the code is pushed to a public repository.

---

## 🔐 The Professional Way: Using a Service Principal with Environment Variables

In a real world scenario, you should authenticate Terraform with Azure using a **Service Principal** and **environment variables**. This keeps your credentials out of your codebase entirely.

### What is a Service Principal?

A Service Principal is an identity created in Azure Active Directory (Azure AD) that is used by applications, services, and automation tools (like Terraform) to access Azure resources. Think of it as a "robot account" with specific permissions assigned to it, instead of using your personal user account.

### Step 1: Log in to Azure

```bash
az login
```

### Step 2: Create a Service Principal

Run the following command to create a Service Principal with **Contributor** role on your subscription.

```bash
az ad sp create-for-rbac \
  --name "my-terraform-sp" \
  --role="Contributor" \
  --scopes="/subscriptions/<YOUR_SUBSCRIPTION_ID>"
```

This will output something like:

```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "my-terraform-sp",
  "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### Step 3: Export Environment Variables

Map the output values to environment variables that the AzureRM provider reads automatically:

```bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<your_subscription_id>"
export ARM_TENANT_ID="<tenant>"
```

| Output Field | Environment Variable   | Description                              |
|:-------------|:-----------------------|:-----------------------------------------|
| appId        | ARM_CLIENT_ID          | The Application (Client) ID              |
| password     | ARM_CLIENT_SECRET      | The Client Secret (password)             |
| (manual)     | ARM_SUBSCRIPTION_ID    | Your Azure Subscription ID               |
| tenant       | ARM_TENANT_ID          | Your Azure AD Tenant ID                  |

### Step 4: Clean Provider Block

When using environment variables, your provider block in `main.tf` stays clean with **no secrets or IDs**:

```hcl
provider "azurerm" {
  features {}
}
```

Terraform will automatically pick up the `ARM_*` environment variables for authentication. No sensitive data needs to be committed to version control.

---

## Comparison: Hardcoded vs Environment Variables

| Aspect                  | Hardcoded in main.tf                  | Environment Variables (Service Principal)   |
|:------------------------|:--------------------------------------|:--------------------------------------------|
| Security                | ❌ Credentials exposed in code        | ✅ Credentials stay outside the codebase     |
| Version Control Safety  | ❌ Secrets pushed to GitHub           | ✅ Nothing sensitive in the repository       |
| Team Collaboration      | ❌ Everyone sees your credentials     | ✅ Each team member uses their own env vars  |
| CI/CD Compatibility     | ❌ Not suitable for pipelines         | ✅ Works seamlessly with CI/CD pipelines     |
| Ease of Rotation        | ❌ Must edit code to rotate secrets   | ✅ Just update the environment variable      |

---

## What This Configuration Does

### 1. Terraform and Provider Setup

The configuration begins by declaring the required provider and version constraints.

| Setting               | Value              |
|:----------------------|:-------------------|
| Provider              | hashicorp/azurerm  |
| Provider Version      | ~> 4.8.0          |
| Terraform Version     | >= 1.9.0           |

The `azurerm` provider is configured with a `features {}` block, which is mandatory for the AzureRM provider to work.

The `resource_provider_registrations = "none"` setting is used because the lab environment does not grant permission to register Azure Resource Providers automatically. In a production environment with proper permissions, this line can be removed.

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
| Name                  | mystorageaccountexample1                     |
| Resource Group        | Inherited from the Resource Group resource   |
| Location              | Inherited from the Resource Group resource   |
| Account Tier          | Standard                                     |
| Replication Type      | LRS (Locally Redundant Storage)              |
| Tag: environment      | dev                                          |

---

## Key Concepts Demonstrated

### Implicit Dependency

The Storage Account references the Resource Group's `name` and `location` using interpolation expressions like `azurerm_resource_group.resource-group-example1.name`. This creates an **implicit dependency**, meaning Terraform automatically understands that the Resource Group must be created before the Storage Account.

### Explicit Dependency (Commented Out)

The configuration also includes a commented out example of an **explicit dependency** using `depends_on`. This is useful when there is no direct reference between resources but you still want to enforce a creation order.

---

## How to Use

1. Make sure you have Terraform installed (version 1.9.0 or above).
2. Install the Azure CLI and log in using `az login`.
3. Create a Service Principal and export the environment variables as described above.
4. Run `terraform init` to initialize the working directory and download the provider.
5. Run `terraform plan` to preview the resources that will be created.
6. To quickly see only the resources that will be created, run:
   ```bash
   terraform plan | grep "will be created"
   ```
7. Run `terraform apply` to create the resources in your Azure subscription.
8. Run `terraform destroy` when you want to remove all the resources.

---

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

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform Overview](https://developer.hashicorp.com/terraform/intro)
- [Terraform Configuration Language](https://developer.hashicorp.com/terraform/language)
- [Terraform Providers](https://developer.hashicorp.com/terraform/language/providers)
- [Terraform Resources](https://developer.hashicorp.com/terraform/language/resources)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [AzureRM Authentication Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure)

### Microsoft Azure Documentation
- [Azure Resource Groups Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups)
- [Azure Storage Account Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Create a Service Principal with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1)
- [Install Terraform on Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/quickstart-configure)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
