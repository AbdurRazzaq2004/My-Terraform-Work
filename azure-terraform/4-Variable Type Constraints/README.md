# Terraform Variable Type Constraints

## Overview

This project demonstrates all the **variable type constraints** available in Terraform. Instead of using only `string` variables, Terraform supports multiple data types like `number`, `bool`, `list`, `map`, `tuple`, and `object`. Understanding these types is essential for writing flexible and reusable Terraform configurations.

---

## What are Variable Type Constraints?

When you declare a variable in Terraform, you can specify a **type** to control what kind of value it accepts. This helps catch errors early. If someone passes the wrong type of value, Terraform will throw an error during `plan` rather than failing during `apply`.

---

## All Variable Types Explained

### 1. String

A `string` is a sequence of characters, like a name or a label.

```hcl
variable "environment" {
  type        = string
  description = "The environment type (e.g., dev, staging, prod)"
  default     = "staging"
}
```

**How it is used in resources:**

```hcl
name = "${var.environment}-resources"    # Result: "staging-resources"
```

The `${}` syntax is called **string interpolation**. It inserts the variable value inside a string.

---

### 2. Number

A `number` represents a numeric value (integer or decimal).

```hcl
variable "storage_disk" {
  type        = number
  description = "The storage disk size of the OS in GB"
  default     = 80
}
```

**How it is used in resources:**

```hcl
disk_size_gb = var.storage_disk    # Result: 80
```

---

### 3. Boolean

A `bool` is either `true` or `false`. It is used to enable or disable a feature.

```hcl
variable "is_delete" {
  type        = bool
  description = "The default behavior to delete the OS disk upon VM termination"
  default     = true
}
```

**How it is used in resources:**

```hcl
delete_os_disk_on_termination = var.is_delete    # Result: true
```

---

### 4. List

A `list` is an ordered collection of values of the **same type**. You access elements by their index (starting from 0).

```hcl
variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Azure locations"
  default     = ["West Europe", "North Europe", "East US"]
}
```

**How it is used in resources:**

```hcl
location = var.allowed_locations[0]    # Result: "West Europe"
location = var.allowed_locations[2]    # Result: "East US"
```

| Index | Value         |
|:------|:--------------|
| 0     | West Europe   |
| 1     | North Europe  |
| 2     | East US       |

---

### 5. Map

A `map` is a collection of **key value pairs** where all values are of the same type. You access values using the key name.

```hcl
variable "resource_tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default = {
    "environment" = "staging"
    "managed_by"  = "terraform"
    "department"  = "devops"
  }
}
```

**How it is used in resources:**

```hcl
environment = var.resource_tags["environment"]    # Result: "staging"
managed_by  = var.resource_tags["managed_by"]     # Result: "terraform"
department  = var.resource_tags["department"]      # Result: "devops"
```

---

### 6. Tuple

A `tuple` is similar to a list but allows **different types** in each position. The order and type of each element is fixed.

```hcl
variable "network_config" {
  type        = tuple([string, string, number])
  description = "Network configuration (VNET address, subnet address, subnet mask)"
  default     = ["10.0.0.0/16", "10.0.2.0", 24]
}
```

**How it is used in resources:**

```hcl
address_space    = [element(var.network_config, 0)]    # Result: "10.0.0.0/16"
address_prefixes = ["${element(var.network_config, 1)}/${element(var.network_config, 2)}"]
                                                        # Result: "10.0.2.0/24"
```

| Index | Type   | Value        | Purpose          |
|:------|:-------|:-------------|:-----------------|
| 0     | string | 10.0.0.0/16  | VNET address     |
| 1     | string | 10.0.2.0     | Subnet address   |
| 2     | number | 24           | Subnet mask      |

**Difference between List and Tuple:**

| Feature        | List                          | Tuple                                  |
|:---------------|:------------------------------|:---------------------------------------|
| Element types  | All elements must be the same type | Each element can be a different type |
| Example        | `["a", "b", "c"]`            | `["10.0.0.0/16", "10.0.2.0", 24]`     |

---

### 7. Object

An `object` is a collection of **named attributes**, each with its own type. It is like a structured data type or a mini schema.

```hcl
variable "vm_config" {
  type = object({
    size      = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Virtual machine configuration"
  default = {
    size      = "Standard_DS1_v2"
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
```

**How it is used in resources:**

```hcl
vm_size   = var.vm_config.size          # Result: "Standard_DS1_v2"
publisher = var.vm_config.publisher     # Result: "Canonical"
sku       = var.vm_config.sku           # Result: "22_04-lts"
```

**Difference between Map and Object:**

| Feature         | Map                              | Object                                       |
|:----------------|:---------------------------------|:---------------------------------------------|
| Structure       | All values must be the same type | Each attribute can have a different type      |
| Key definition  | Keys are flexible                | Attributes are predefined in the type schema  |
| Use case        | Dynamic key value pairs          | Structured, predictable data                  |

---

## Summary Table of All Variable Types

| Type          | Description                                | Access Method                     | Example Value                          |
|:--------------|:-------------------------------------------|:----------------------------------|:---------------------------------------|
| `string`      | A text value                               | `var.environment`                 | `"staging"`                            |
| `number`      | A numeric value                            | `var.storage_disk`                | `80`                                   |
| `bool`        | A true or false value                      | `var.is_delete`                   | `true`                                 |
| `list(string)`| An ordered list of same type values        | `var.allowed_locations[0]`        | `["West Europe", "East US"]`           |
| `map(string)` | Key value pairs of same type values        | `var.resource_tags["key"]`        | `{"env" = "staging"}`                  |
| `tuple`       | Ordered list with different types per index| `element(var.network_config, 0)`  | `["10.0.0.0/16", "10.0.2.0", 24]`     |
| `object`      | Named attributes with different types      | `var.vm_config.size`              | `{size = "Standard_DS1_v2", ...}`      |

---

## Resources Created in This Project

This project creates a complete VM infrastructure to demonstrate how each variable type is used in real resources:

| Resource                  | Variable Types Used                              |
|:--------------------------|:-------------------------------------------------|
| **Resource Group**        | `string` (environment), `list` (allowed_locations) |
| **Virtual Network**       | `string` (environment), `tuple` (network_config)  |
| **Subnet**                | `tuple` (network_config)                          |
| **Network Interface**     | `string` (environment)                            |
| **Virtual Machine**       | `list` (allowed_vm_sizes), `bool` (is_delete), `object` (vm_config), `number` (storage_disk), `map` (resource_tags) |

---

## File Structure

```
Variable Type Constraints/
│
├── provider.tf      # Terraform and AzureRM provider configuration
├── backend.tf       # Remote backend configuration (Azure Blob Storage)
├── variables.tf     # All variable declarations with type constraints
├── local.tf         # Local values (common tags)
├── main.tf          # All Azure resources (RG, VNET, Subnet, NIC, VM)
├── output.tf        # Output values displayed after apply
├── .gitignore       # Files to exclude from version control
└── README.md        # Documentation (this file)
```

---

## How to Use

1. Update `provider.tf` with your Azure `subscription_id`.
2. Update `backend.tf` with your remote backend storage details (or remove it to use local state).
3. Run the following commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
4. To see only the resources that will be created:
   ```bash
   terraform plan | grep "will be created"
   ```
5. To destroy all resources:
   ```bash
   terraform destroy
   ```

---

## Prerequisites

1. **Terraform** version 1.9.0 or later
2. **Azure CLI** installed and authenticated (`az login`)
3. An active **Azure Subscription**

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform Variable Types](https://developer.hashicorp.com/terraform/language/expressions/types)
- [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Terraform Type Constraints](https://developer.hashicorp.com/terraform/language/expressions/type-constraints)
- [Terraform Collection Types (list, map, set)](https://developer.hashicorp.com/terraform/language/expressions/types#collection-types)
- [Terraform Structural Types (object, tuple)](https://developer.hashicorp.com/terraform/language/expressions/types#structural-types)
- [Terraform Variable Validation](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Microsoft Azure Documentation
- [Azure Virtual Machines Overview](https://learn.microsoft.com/en-us/azure/virtual-machines/overview)
- [Azure Virtual Network Overview](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)
- [Azure Storage Account Overview](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview)
- [Azure VM Sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
- [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
- [azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
- [azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)

### Course Reference
- [Day 07 Terraform Course](https://github.com/piyushsachdeva/Terraform-Full-Course-Azure/tree/main/lessons/day07)
