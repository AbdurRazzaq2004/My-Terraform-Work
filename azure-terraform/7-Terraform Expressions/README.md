# Terraform Expressions

This folder demonstrates **Terraform Expressions** including Dynamic Blocks, Conditional Expressions, and Splat Expressions. These are powerful features that make your Terraform configurations more flexible and reusable. This is based on **Day 10** of the Terraform course.

---

## 📁 File Structure

| File | Description |
|------|-------------|
| `provider.tf` | Configures the AzureRM provider with subscription ID and feature block |
| `backend.tf` | Configures remote state storage in Azure Blob Storage |
| `variables.tf` | Defines input variables for environment and storage account names |
| `local.tf` | Defines NSG rules as local values used by the dynamic block |
| `main.tf` | Creates resource group and NSG with dynamic block and conditional expression |
| `output.tf` | Outputs using splat expressions and for expressions |
| `.gitignore` | Excludes Terraform cache and state files from version control |

---

## 🧠 What Are Terraform Expressions?

Terraform expressions are used to **compute values**, **make decisions**, and **generate repetitive blocks** dynamically. They help you write cleaner, more flexible, and DRY (Don't Repeat Yourself) configurations.

There are three main types of expressions covered in this lesson:

| # | Expression Type | Purpose |
|---|----------------|---------|
| 1 | **Dynamic Expressions** | Generate repetitive nested blocks dynamically from a collection |
| 2 | **Conditional Expressions** | Choose between two values based on a condition |
| 3 | **Splat Expressions** | Extract a specific attribute from all items in a list |

---

## 1️⃣ Dynamic Expressions (Dynamic Blocks)

### The Problem

Imagine you need to create a Network Security Group (NSG) with 10 security rules. Without dynamic blocks, you would have to write 10 separate `security_rule` blocks manually, each with almost identical structure. This leads to:

- **Code duplication**
- **Hard to maintain** configurations
- **Error prone** manual repetition

### The Solution

A `dynamic` block generates multiple **nested blocks** from a collection (map, list, or set). Instead of writing each block manually, you define the structure once and let Terraform generate them.

### Syntax

```hcl
dynamic "<block_label>" {
  for_each = <collection>
  content {
    # Use <block_label>.key and <block_label>.value
    # to access each item
  }
}
```

### How We Used It

First, we defined the NSG rules as **local values** in `local.tf`:

```hcl
locals {
  nsg_rules = {
    "allow_ssh" = {
      priority               = 100
      destination_port_range = "22"
      description            = "Allow SSH"
    },
    "allow_http" = {
      priority               = 110
      destination_port_range = "80"
      description            = "Allow HTTP"
    },
    "allow_https" = {
      priority               = 120
      destination_port_range = "443"
      description            = "Allow HTTPS"
    }
  }
}
```

Then, we used a `dynamic` block in `main.tf` to generate the security rules:

```hcl
resource "azurerm_network_security_group" "example" {
  name                = "nsg-dev-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}
```

### How the Dynamic Block Works

| Component | Description |
|-----------|-------------|
| `dynamic "security_rule"` | The label must match the nested block name of the resource |
| `for_each = local.nsg_rules` | Iterates over each item in the map |
| `security_rule.key` | The key of the current item (e.g., `"allow_ssh"`) |
| `security_rule.value` | The value of the current item (the inner map with priority, port, etc.) |
| `content { }` | The actual block that gets generated for each item |

### What Terraform Generates

The dynamic block above generates **3 separate security_rule blocks** automatically:

```
security_rule "allow_ssh"   → priority: 100, port: 22
security_rule "allow_http"  → priority: 110, port: 80
security_rule "allow_https" → priority: 120, port: 443
```

---

## 2️⃣ Conditional Expressions

### What Is a Conditional Expression?

A conditional expression in Terraform works like a **ternary operator** in other programming languages. It selects one of two values based on whether a condition is true or false.

### Syntax

```hcl
condition ? value_if_true : value_if_false
```

### How We Used It

We used a conditional expression to set the NSG name based on the environment:

```hcl
resource "azurerm_network_security_group" "example" {
  name = var.environment == "dev" ? "nsg-dev-vm" : "nsg-stage-vm"
  # ...
}
```

### How It Works

| Condition | Result |
|-----------|--------|
| `var.environment == "dev"` is **true** | Name becomes `"nsg-dev-vm"` |
| `var.environment == "dev"` is **false** | Name becomes `"nsg-stage-vm"` |

### More Examples

```hcl
# Choose VM size based on environment
vm_size = var.environment == "prod" ? "Standard_DS2_v2" : "Standard_DS1_v2"

# Enable or disable features
enable_https = var.environment == "prod" ? true : false

# Choose replication type
account_replication_type = var.environment == "prod" ? "GRS" : "LRS"

# Nested conditional (not recommended but possible)
location = var.environment == "prod" ? "East US" : var.environment == "dev" ? "West US" : "North Europe"
```

### Conditional Expression vs If/Else

Terraform does **not** have traditional `if/else` statements. The conditional expression (`? :`) is the only way to make decisions inline. For more complex logic, use `count` or `for_each` with conditions:

```hcl
# Create resource only if environment is prod
resource "azurerm_resource_group" "prod_only" {
  count    = var.environment == "prod" ? 1 : 0
  name     = "prod-resources"
  location = "East US"
}
```

---

## 3️⃣ Splat Expressions

### What Is a Splat Expression?

A splat expression provides a **shorthand** way to extract a specific attribute from all elements in a list. It uses the `[*]` operator.

### Syntax

```hcl
<resource_or_list>[*].<attribute>
```

### How We Used It

We used splat expressions in outputs to extract specific attributes from all NSG security rules:

```hcl
# Get all rule names
output "security_rule_names" {
  value = azurerm_network_security_group.example.security_rule[*].name
}

# Get all rule priorities
output "security_rule_priorities" {
  value = azurerm_network_security_group.example.security_rule[*].priority
}

# Get all source port ranges
output "security_rule_source_ports" {
  value = azurerm_network_security_group.example.security_rule[*].source_port_range
}
```

### Example Output

```
security_rule_names      = ["allow_http", "allow_https", "allow_ssh"]
security_rule_priorities = [110, 120, 100]
security_rule_source_ports = ["*", "*", "*"]
```

### Splat Expression vs For Expression

Both can achieve similar results, but splat is shorter:

| Method | Syntax | Result |
|--------|--------|--------|
| **Splat** | `resource[*].name` | `["name1", "name2", "name3"]` |
| **For** | `[for r in resource : r.name]` | `["name1", "name2", "name3"]` |

The `for` expression is more flexible and allows filtering and transformation:

```hcl
# Splat: get all names
azurerm_network_security_group.example.security_rule[*].name

# For: get all names (same result)
[for rule in azurerm_network_security_group.example.security_rule : rule.name]

# For: get names with filtering (splat cannot do this)
[for rule in azurerm_network_security_group.example.security_rule : rule.name if rule.priority > 100]
```

---

## 🔄 Comparison of All Three Expression Types

| Feature | Dynamic Block | Conditional Expression | Splat Expression |
|---------|--------------|----------------------|-----------------|
| **Purpose** | Generate repetitive nested blocks | Choose between two values | Extract attributes from lists |
| **Syntax** | `dynamic "block" { }` | `condition ? a : b` | `list[*].attr` |
| **Input** | Map, list, or set | Boolean condition | List or resource |
| **Output** | Multiple nested blocks | Single value | List of values |
| **Use Case** | NSG rules, tags, ingress rules | Environment based naming | Collecting outputs |

---

## 🎯 What We Did in This Project

1. **Created local values** in `local.tf` defining 3 NSG rules (SSH, HTTP, HTTPS) with priority, port, and description
2. **Used a dynamic block** in `main.tf` to automatically generate all 3 security rules from the local map
3. **Applied a conditional expression** to set the NSG name based on the environment variable (`dev` or `stage`)
4. **Used splat expressions** in `output.tf` to extract rule names, priorities, and source port ranges
5. **Used a for expression** to iterate over local values and extract descriptions

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
| Dynamic Block | Generates repetitive nested blocks from a collection (map, list, set) |
| `security_rule.key` | Accesses the key of the current item in a dynamic block |
| `security_rule.value` | Accesses the value of the current item in a dynamic block |
| Conditional Expression | `condition ? true_value : false_value` (like ternary operator) |
| Splat Expression | `[*].attribute` extracts a specific attribute from all list items |
| For Expression | `[for item in collection : item.attr]` more flexible than splat |
| Local Values | Great for defining data that dynamic blocks iterate over |
| `count` with condition | `count = condition ? 1 : 0` to conditionally create resources |

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform Expressions Overview](https://developer.hashicorp.com/terraform/language/expressions)
- [Terraform Dynamic Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)
- [Terraform Conditional Expressions](https://developer.hashicorp.com/terraform/language/expressions/conditionals)
- [Terraform Splat Expressions](https://developer.hashicorp.com/terraform/language/expressions/splat)
- [Terraform For Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)
- [Terraform Local Values](https://developer.hashicorp.com/terraform/language/values/locals)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Microsoft Azure Documentation
- [Azure Network Security Groups Overview](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
- [Azure NSG Security Rules](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-group-how-it-works)
- [Azure Resource Groups Overview](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview#resource-groups)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)
