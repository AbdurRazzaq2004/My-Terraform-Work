# Lifecycle Rules in Terraform

This folder demonstrates the **Lifecycle Rules** in Terraform, which allow you to control how Terraform creates, updates, and destroys resources. This is based on **Day 09** of the Terraform course.

## 📝 Handwritten Notes

![Lifecycle Rules Notes](images/lifecycle-rules-notes.png)

---

## 📁 File Structure

| File | Description |
|------|-------------|
| `provider.tf` | Configures the AzureRM provider with subscription ID and feature block |
| `backend.tf` | Configures remote state storage in Azure Blob Storage |
| `variables.tf` | Defines input variables including location and allowed locations for validation |
| `local.tf` | Defines local values for common tags |
| `main.tf` | Contains resource group and storage accounts with lifecycle rules applied |
| `output.tf` | Outputs resource group name, location, and storage account names |
| `.gitignore` | Excludes Terraform cache and state files from version control |

---

## 🧠 What Are Lifecycle Rules?

Lifecycle rules are a **meta argument** in Terraform that let you customize how resources are managed during their lifecycle. They control what happens when a resource is **created**, **updated**, or **destroyed**.

You define lifecycle rules inside a `lifecycle` block within any resource:

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "East US"

  lifecycle {
    create_before_destroy = true
  }
}
```

---

## 🔧 Lifecycle Rule Options

Terraform provides **5 lifecycle options** plus **custom conditions**:

| # | Option | Description |
|---|--------|-------------|
| 1 | `create_before_destroy` | Creates the new resource before destroying the old one |
| 2 | `prevent_destroy` | Prevents Terraform from destroying the resource |
| 3 | `ignore_changes` | Ignores changes to specified attributes during plan and apply |
| 4 | `replace_triggered_by` | Forces replacement when a referenced resource or attribute changes |
| 5 | `precondition` / `postcondition` | Custom validation rules that must pass before or after resource operations |

---

## 1️⃣ create_before_destroy

By default, when Terraform needs to replace a resource (destroy and recreate), it **destroys the old resource first** and then creates the new one. This can cause **downtime**.

With `create_before_destroy = true`, Terraform **creates the new resource first** and only destroys the old one after the new one is successfully created.

### Example

```hcl
resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  lifecycle {
    create_before_destroy = true
  }
}
```

### When to Use

- When you need **zero downtime** during resource replacement
- When renaming resources that cannot be updated in place
- When the new resource must be verified before the old one is removed

### Default Behavior vs create_before_destroy

| Step | Default Behavior | create_before_destroy |
|------|-----------------|----------------------|
| 1 | Destroy old resource | Create new resource |
| 2 | Create new resource | Verify new resource is ready |
| 3 | — | Destroy old resource |

---

## 2️⃣ prevent_destroy

When `prevent_destroy = true`, Terraform will **throw an error** if any operation would result in destroying the resource. This is a safety mechanism to protect critical resources.

### Example

```hcl
resource "azurerm_resource_group" "example" {
  name     = "production-resources"
  location = "East US"

  lifecycle {
    prevent_destroy = true
  }
}
```

### What Happens When You Try to Destroy

```
Error: Instance cannot be destroyed

  on main.tf line 1:
   1: resource "azurerm_resource_group" "example" {

Resource azurerm_resource_group.example has
lifecycle.prevent_destroy set, but the plan calls
for this resource to be destroyed.
```

### When to Use

- **Production databases** that should never be accidentally deleted
- **Resource groups** containing critical infrastructure
- **Storage accounts** with important data
- Any resource where accidental deletion would cause data loss

### ⚠️ Important Note

`prevent_destroy` only prevents destruction through Terraform. It does **not** prevent manual deletion through the Azure Portal or CLI. To protect against manual deletion, use **Azure Resource Locks**.

---

## 3️⃣ ignore_changes

The `ignore_changes` argument tells Terraform to **ignore changes** made to specific attributes after the resource is created. This is useful when changes are made **outside of Terraform** (for example, through the Azure Portal) and you don't want Terraform to revert them.

### Example: Ignore Tag Changes

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "East US"

  tags = {
    environment = "staging"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
```

### Example: Ignore Multiple Attributes

```hcl
resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  lifecycle {
    ignore_changes = [account_replication_type, tags]
  }
}
```

### Example: Ignore All Changes

```hcl
lifecycle {
  ignore_changes = all
}
```

Using `all` tells Terraform to completely ignore any changes to the resource after it is created.

### When to Use

- When other teams or automation tools modify tags outside Terraform
- When Azure automatically adds or modifies certain attributes
- When you want Terraform to manage the initial creation but not ongoing changes

---

## 4️⃣ replace_triggered_by

The `replace_triggered_by` argument forces Terraform to **replace** a resource whenever a specified reference changes. This is useful when two resources are related but Terraform doesn't automatically detect that a change in one should trigger recreation of the other.

### Example

```hcl
resource "azurerm_storage_account" "example" {
  for_each = var.storage_account_name

  name                     = each.value
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  lifecycle {
    replace_triggered_by = [azurerm_resource_group.example.id]
  }
}
```

### How It Works

- If the resource group is recreated (gets a new ID), all storage accounts will also be **destroyed and recreated**
- The trigger can reference any resource attribute, not just IDs
- You can specify multiple triggers in the list

### When to Use

- When child resources should be recreated if the parent resource changes
- When resources have hidden dependencies that Terraform cannot detect
- When a configuration change in one resource requires fresh creation of another

---

## 5️⃣ precondition and postcondition

Custom conditions allow you to add **validation rules** that Terraform checks before (`precondition`) or after (`postcondition`) managing a resource.

### Example: precondition

```hcl
resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.location

  lifecycle {
    precondition {
      condition     = contains(var.allowed_locations, var.location)
      error_message = "Please enter a valid location! Allowed: ${join(", ", var.allowed_locations)}"
    }
  }
}
```

### What Happens When Validation Fails

```
Error: Resource precondition failed

  on main.tf line 12, in resource "azurerm_resource_group" "example":
  12:       condition = contains(var.allowed_locations, var.location)

Please enter a valid location! Allowed: West Europe, North Europe, East US
```

### precondition vs postcondition

| Feature | precondition | postcondition |
|---------|-------------|---------------|
| **When it runs** | Before the resource is created or updated | After the resource is created or updated |
| **Purpose** | Validate input values | Validate the result of the operation |
| **Fails on** | Invalid inputs | Unexpected outputs |
| **Access to** | Variables and other resources | The resource's own attributes using `self` |

### postcondition Example

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "East US"

  lifecycle {
    postcondition {
      condition     = self.id != ""
      error_message = "Resource group was not created successfully!"
    }
  }
}
```

---

## 🎯 What We Did in This Project

1. **Applied `create_before_destroy`** to both the resource group and storage accounts to ensure zero downtime during replacements
2. **Configured `prevent_destroy`** on the resource group (set to false for testing, set to true for production)
3. **Added `ignore_changes`** on the storage account to ignore changes to `account_replication_type` made outside Terraform
4. **Used `replace_triggered_by`** to automatically recreate storage accounts when the resource group changes
5. **Implemented `precondition`** to validate that the location is one of the allowed locations before creating resources

---

## 🧪 Task: Test the Lifecycle Rules

Try these experiments to understand how each lifecycle rule works:

| # | Experiment | What to Do | Expected Result |
|---|-----------|------------|-----------------|
| 1 | Test `create_before_destroy` | Change a storage account name and run `terraform apply` | New account is created first, then old one is destroyed |
| 2 | Test `prevent_destroy` | Set `prevent_destroy = true` on the resource group, then run `terraform destroy` | Terraform throws an error and refuses to destroy |
| 3 | Test `ignore_changes` | Manually change the replication type in Azure Portal, then run `terraform plan` | Terraform shows no changes for that attribute |
| 4 | Test `precondition` | Change the location variable to `"Canada Central"` and run `terraform plan` | Terraform throws a validation error |

---

## 🔧 Commands Used

```bash
# Initialize Terraform with backend configuration
terraform init

# Validate the configuration
terraform validate

# Preview the changes
terraform plan

# Apply the changes
terraform apply

# Check what will be created
terraform plan | grep "will be created"

# Destroy all resources
terraform destroy
```

---

## 📌 Key Takeaways

| Concept | Summary |
|---------|---------|
| `create_before_destroy` | Creates the replacement resource before destroying the original (zero downtime) |
| `prevent_destroy` | Blocks any operation that would destroy the resource (safety net) |
| `ignore_changes` | Ignores external changes to specified attributes (prevents drift correction) |
| `replace_triggered_by` | Forces replacement when a referenced resource or attribute changes |
| `precondition` | Validates inputs before resource creation |
| `postcondition` | Validates outputs after resource creation using `self` |
| `ignore_changes = all` | Ignores all attribute changes after initial creation |

---

## ⚠️ Common Mistakes

| Mistake | Solution |
|---------|----------|
| Setting `prevent_destroy = true` and then running `terraform destroy` | Remove or set to `false` before destroying |
| Using `ignore_changes` on required attributes | Only ignore optional or externally managed attributes |
| Forgetting that `prevent_destroy` doesn't protect against Azure Portal deletion | Use Azure Resource Locks for full protection |
| Using `create_before_destroy` on resources that don't support it | Not all resources can have two instances at the same time (e.g., unique names) |

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform Lifecycle Meta Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
- [Terraform Preconditions and Postconditions](https://developer.hashicorp.com/terraform/language/expressions/custom-conditions)
- [Terraform create_before_destroy](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#create_before_destroy)
- [Terraform prevent_destroy](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#prevent_destroy)
- [Terraform ignore_changes](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes)
- [Terraform replace_triggered_by](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#replace_triggered_by)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Microsoft Azure Documentation
- [Azure Resource Groups Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups)
- [Azure Storage Account Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Azure Resource Locks](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources)
- [Prevent Accidental Deletion of Azure Resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/lock-resources?tabs=json#who-can-create-or-delete-locks)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

### Course Reference
- [Day 09 Terraform Course](https://github.com/piyushsachdeva/Terraform-Full-Course-Azure/tree/main/lessons/day09)
