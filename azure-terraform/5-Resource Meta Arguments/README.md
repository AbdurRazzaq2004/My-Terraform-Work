# Resource Meta Arguments in Terraform

This folder demonstrates the use of **Resource Meta Arguments** in Terraform. Meta arguments are special arguments that can be used with any resource block to change the behavior of resources. This is based on **Day 08** of the Terraform course.

## 📝 Handwritten Notes

![Meta Arguments Notes](images/meta-arguments-notes.png)

---

## 📁 File Structure

| File | Description |
|------|-------------|
| `provider.tf` | Configures the AzureRM provider with subscription ID and feature block |
| `backend.tf` | Configures remote state storage in Azure Blob Storage |
| `variables.tf` | Defines all input variables including the new `set(string)` type |
| `local.tf` | Defines local values for common tags |
| `main.tf` | Contains resource definitions using `for_each` and commented out `count` approach |
| `output.tf` | Outputs storage account names using a `for` loop |
| `.gitignore` | Excludes Terraform cache and state files from version control |

---

## 🧠 What Are Meta Arguments?

Meta arguments are special arguments provided by Terraform that can be used inside any `resource` block to control the behavior of that resource. They are **not specific** to any provider and work across all resource types.

Terraform supports **5 meta arguments**:

| # | Meta Argument | Purpose |
|---|---------------|---------|
| 1 | `depends_on` | Explicitly define dependencies between resources |
| 2 | `count` | Create multiple instances of a resource using an index |
| 3 | `for_each` | Create multiple instances of a resource using a set or map |
| 4 | `provider` | Select a non default provider configuration |
| 5 | `lifecycle` | Control the lifecycle behavior of a resource |

---

## 1️⃣ depends_on

The `depends_on` meta argument is used to **explicitly specify** that one resource depends on another. Terraform automatically figures out dependencies based on references, but sometimes you need to declare them manually when there is a **hidden dependency** that Terraform cannot detect.

### Example

```hcl
resource "azurerm_storage_account" "example" {
  depends_on = [azurerm_resource_group.example]

  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
```

### When to Use

- When Terraform cannot automatically detect the dependency
- When one resource must be fully created before another starts
- When using modules that have implicit dependencies

---

## 2️⃣ count

The `count` meta argument allows you to create **multiple instances** of the same resource. Each instance is identified by its **index number** starting from `0`.

### Example

```hcl
variable "storage_account_name" {
  type    = list(string)
  default = ["storageaccount01", "storageaccount02"]
}

resource "azurerm_storage_account" "example" {
  count = length(var.storage_account_name)

  name                     = var.storage_account_name[count.index]
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
```

### How It Works

- `count = 2` creates 2 instances of the resource
- `count.index` gives the current index (0, 1, 2, ...)
- Resources are identified as `azurerm_storage_account.example[0]`, `azurerm_storage_account.example[1]`, etc.
- Use `length()` function to dynamically set the count based on a list variable

### ⚠️ Problem with count

If you remove an item from the **middle** of the list, Terraform will destroy and recreate all resources after that index because they are identified by index position, not by value.

---

## 3️⃣ for_each

The `for_each` meta argument is the **recommended approach** for creating multiple instances when each instance needs to be uniquely identifiable. It works with `set(string)` or `map` types.

### Example (Used in This Project)

```hcl
variable "storage_account_name" {
  type    = set(string)
  default = ["techtutorials11", "techtutorials12"]
}

resource "azurerm_storage_account" "example" {
  for_each = var.storage_account_name

  name                     = each.value
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
```

### How It Works

- `for_each` accepts a `set` or `map` value
- `each.key` gives the current key (for sets, the key equals the value)
- `each.value` gives the current value
- Resources are identified by their key: `azurerm_storage_account.example["techtutorials11"]`
- Removing an item only destroys that **specific** resource, not others

---

## 🔄 count vs for_each Comparison

| Feature | count | for_each |
|---------|-------|----------|
| **Input Type** | Number (integer) | Set or Map |
| **Identifier** | Index number (0, 1, 2...) | Key name (string) |
| **Reference** | `resource.name[0]` | `resource.name["key"]` |
| **Adding Items** | May cause recreation | Only creates the new item |
| **Removing Items** | Recreates all items after the removed index | Only destroys the specific item |
| **Best For** | Identical resources | Uniquely identifiable resources |
| **Recommended** | ❌ Not for production | ✅ Preferred approach |

### Why for_each Is Better

With `count`, resources are tracked by index. If you have 3 storage accounts and remove the second one, Terraform sees:
- Index 0 → unchanged
- Index 1 → changed (was item 2, now item 3)
- Index 2 → destroyed (no longer exists)

This causes **unnecessary destruction and recreation**. With `for_each`, resources are tracked by their key name, so removing one only affects that specific resource.

---

## 4️⃣ provider

The `provider` meta argument allows you to specify which **provider configuration** a resource should use. This is useful when you have multiple configurations of the same provider (for example, deploying resources in different regions or different subscriptions).

### Example

```hcl
provider "azurerm" {
  alias = "west"
  features {}
  subscription_id = "xxxx-xxxx-xxxx"
}

provider "azurerm" {
  alias = "east"
  features {}
  subscription_id = "yyyy-yyyy-yyyy"
}

resource "azurerm_resource_group" "west_rg" {
  provider = azurerm.west
  name     = "west-resources"
  location = "West US"
}

resource "azurerm_resource_group" "east_rg" {
  provider = azurerm.east
  name     = "east-resources"
  location = "East US"
}
```

### When to Use

- Deploying resources across multiple Azure regions
- Managing resources in different subscriptions
- Working with multiple cloud accounts

---

## 5️⃣ lifecycle

The `lifecycle` meta argument controls how Terraform manages the lifecycle of a resource. It has several sub features:

### Sub Features

| Sub Feature | Description |
|-------------|-------------|
| `create_before_destroy` | Creates the new resource before destroying the old one |
| `prevent_destroy` | Prevents Terraform from destroying the resource |
| `ignore_changes` | Ignores changes to specified attributes during updates |
| `replace_triggered_by` | Forces replacement when a referenced resource changes |
| `precondition` / `postcondition` | Custom validation rules for the resource |

### Example: create_before_destroy

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

### Example: prevent_destroy

```hcl
resource "azurerm_resource_group" "example" {
  name     = "production-resources"
  location = "East US"

  lifecycle {
    prevent_destroy = true
  }
}
```

### Example: ignore_changes

```hcl
resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  lifecycle {
    ignore_changes = [tags]
  }
}
```

This tells Terraform to **ignore** any manual changes made to the `tags` attribute outside of Terraform.

---

## 📤 Output Using for Loop

When using `for_each`, outputs need a `for` loop to iterate over all instances:

```hcl
output "storage_name" {
  value = [for i in azurerm_storage_account.example : i.name]
}
```

This creates a list of all storage account names created by the `for_each` block.

---

## 🎯 What We Did in This Project

1. **Created a resource group** using string interpolation with the environment variable
2. **Created multiple storage accounts** using the `for_each` meta argument with a `set(string)` variable
3. **Included a commented out alternative** using `count` for comparison
4. **Used a for loop in outputs** to list all created storage account names
5. **Demonstrated the new `set(string)` variable type** which is required for `for_each`

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
| Meta Arguments | Special arguments that work with any resource block |
| depends_on | Explicitly define resource dependencies |
| count | Create multiple resources using index numbers |
| for_each | Create multiple resources using unique keys (recommended) |
| provider | Use specific provider configurations for resources |
| lifecycle | Control creation, destruction, and update behavior |
| set(string) | Required variable type for `for_each` (no duplicates allowed) |
| each.key / each.value | Access current item in `for_each` iteration |
| count.index | Access current index in `count` iteration |

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform Meta Arguments Overview](https://developer.hashicorp.com/terraform/language/meta-arguments)
- [Terraform for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
- [Terraform count](https://developer.hashicorp.com/terraform/language/meta-arguments/count)
- [Terraform depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)
- [Terraform lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
- [Terraform provider Meta Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider)
- [Terraform for Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Microsoft Azure Documentation
- [Azure Resource Groups Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups)
- [Azure Storage Account Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Azure Storage Redundancy](https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
