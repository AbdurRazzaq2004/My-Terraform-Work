# Terraform Functions

This folder demonstrates **Terraform Built in Functions** through practical assignments. Functions are pre built operations that transform, combine, and validate data inside your Terraform configurations. This is based on **Day 11 and Day 12** of the Terraform course.

---

## 📁 File Structure

| File | Description |
|------|-------------|
| `provider.tf` | Configures the AzureRM provider with subscription ID and feature block |
| `backend.tf` | Configures remote state storage in Azure Blob Storage |
| `variables.tf` | Defines all input variables with validation rules |
| `local.tf` | Contains all function usage organized by assignment |
| `main.tf` | Creates resource group, storage account, and NSG using function outputs |
| `output.tf` | Displays results of each function operation |
| `.gitignore` | Excludes Terraform cache and state files from version control |

---

## 🧠 What Are Terraform Functions?

Terraform functions are **pre built operations** that you can call inside expressions to transform and combine values. Unlike resources or variables, you **cannot define your own functions** in Terraform. You can only use the ones that Terraform provides.

### Why Do We Use Functions?

| Problem | Function Solution |
|---------|-------------------|
| Resource names must be lowercase | `lower()` converts any string to lowercase |
| Need to remove spaces from names | `replace()` replaces characters in a string |
| Storage account name has a max length | `substr()` extracts a portion of a string |
| Need to combine two tag maps | `merge()` merges multiple maps into one |
| Ports come as a comma separated string | `split()` converts a string into a list |
| Need to find the right VM size for an environment | `lookup()` searches a map with a fallback value |
| Need to remove duplicate locations | `toset()` converts a list to a set (unique values) |
| Need to find the maximum cost | `max()` returns the largest number |
| Need timestamps on resources | `timestamp()` and `formatdate()` generate formatted dates |
| Need to protect sensitive values | `sensitive()` marks a value as sensitive |

### When Do We Use Functions?

- **Always in expressions**: Inside `locals`, `variable` defaults, `output` values, and resource arguments
- **Never standalone**: Functions cannot exist outside of an expression
- **Test first in console**: Use `terraform console` to test any function before using it in code

---

## 🔧 Function Categories

Terraform groups its functions into these categories:

| Category | Purpose | Examples |
|----------|---------|----------|
| **String** | Manipulate text | `lower()`, `upper()`, `replace()`, `substr()`, `split()`, `join()`, `trim()` |
| **Numeric** | Work with numbers | `abs()`, `max()`, `min()`, `ceil()`, `floor()` |
| **Collection** | Work with lists, maps, sets | `merge()`, `concat()`, `toset()`, `lookup()`, `contains()`, `length()` |
| **Type Conversion** | Convert between types | `tostring()`, `tonumber()`, `tolist()`, `tomap()`, `toset()` |
| **Date and Time** | Work with timestamps | `timestamp()`, `formatdate()` |
| **Filesystem** | Read files | `file()`, `fileexists()`, `dirname()`, `basename()` |
| **Encoding** | Encode/decode data | `jsonencode()`, `jsondecode()`, `base64encode()`, `base64decode()` |
| **Hash and Crypto** | Generate hashes | `md5()`, `sha256()`, `bcrypt()` |

---

## 📝 Assignments and Functions Used

### Assignment 1: Project Naming Convention

**Functions**: `lower()`, `replace()`

**Why**: Azure resource names should follow a consistent naming convention. Company standards often require lowercase names with hyphens instead of spaces.

**When**: Every time you create resources from user input or variable values that might contain uppercase letters or spaces.

```hcl
# Input:  "Project ALPHA Resource"
# Output: "project-alpha-resource"

locals {
  formatted_name = lower(replace(var.project_name, " ", "-"))
}
```

| Function | What It Does | Input | Output |
|----------|-------------|-------|--------|
| `replace(string, search, replacement)` | Replaces all occurrences of `search` with `replacement` | `"Project ALPHA Resource", " ", "-"` | `"Project-ALPHA-Resource"` |
| `lower(string)` | Converts all characters to lowercase | `"Project-ALPHA-Resource"` | `"project-alpha-resource"` |

---

### Assignment 2: Resource Tagging

**Function**: `merge()`

**Why**: In real projects, you have **default tags** that apply to every resource (company name, managed_by) and **environment specific tags** (environment, cost_center). Instead of manually combining them, `merge()` does it automatically.

**When**: Every time you need to combine multiple maps into one. Common for tags, labels, and configuration maps.

```hcl
# Default tags:     { company = "CloudOps", managed_by = "terraform" }
# Environment tags: { environment = "production", cost_center = "cc-123" }
# Merged result:    { company = "CloudOps", managed_by = "terraform", environment = "production", cost_center = "cc-123" }

locals {
  merge_tags = merge(var.default_tags, var.environment_tags)
}
```

| Function | What It Does |
|----------|-------------|
| `merge(map1, map2, ...)` | Combines multiple maps into one. If the same key exists in multiple maps, the **last map wins** |

---

### Assignment 3: Storage Account Naming

**Functions**: `substr()`, `lower()`, `replace()`

**Why**: Azure storage account names have strict requirements: **maximum 24 characters**, **only lowercase letters and numbers**, **no spaces or special characters**. If a user provides a raw name, it must be formatted before use.

**When**: Any time you need to enforce naming constraints on Azure resources.

```hcl
# Input:  "techtutorIALS with!piyushthis should be formatted"
# Step 1: substr(input, 0, 23)  → "techtutorIALS with!piyu"
# Step 2: lower(step1)          → "techtutorials with!piyu"
# Step 3: replace(step2, " ", "")  → "techtutorialswith!piyu"
# Step 4: replace(step3, "!", "")  → "techtutorialswithpiyu"

locals {
  storage_formatted = replace(replace(lower(substr(var.storage_account_name, 0, 23)), " ", ""), "!", "")
}
```

| Function | What It Does | Why We Need It |
|----------|-------------|----------------|
| `substr(string, offset, length)` | Extracts a substring starting at `offset` for `length` characters | Enforces the 24 character limit |
| `lower(string)` | Converts to lowercase | Azure requires lowercase only |
| `replace(string, search, replace)` | Removes unwanted characters | Removes spaces and special characters |

---

### Assignment 4: NSG Port Rules

**Functions**: `split()`, for expression

**Why**: Ports often come as a **comma separated string** (from APIs, config files, or user input). You need to convert them into individual NSG rules. Instead of writing each rule manually, `split()` breaks the string and a `for` expression builds the rule objects.

**When**: When you receive structured data as a single string and need to process each item individually.

```hcl
# Input:  "80,443,3306"
# After split: ["80", "443", "3306"]
# After for: [
#   { name = "port-80",   port = "80",   description = "Allowed traffic on port: 80" },
#   { name = "port-443",  port = "443",  description = "Allowed traffic on port: 443" },
#   { name = "port-3306", port = "3306", description = "Allowed traffic on port: 3306" }
# ]

locals {
  formatted_ports = split(",", var.allowed_ports)
  nsg_rules = [for port in local.formatted_ports : {
    name        = "port-${port}"
    port        = port
    description = "Allowed traffic on port: ${port}"
  }]
}
```

| Function | What It Does |
|----------|-------------|
| `split(separator, string)` | Splits a string into a list by the separator |
| `join(separator, list)` | The opposite of split: joins a list into a string |

---

### Assignment 5: Resource Lookup

**Function**: `lookup()`

**Why**: Different environments need different configurations (VM sizes, replication types, etc.). Instead of writing complex conditional expressions, `lookup()` searches a map and returns the matching value. If the key is not found, it returns a **fallback value**.

**When**: Any time you need environment based configuration mapping.

```hcl
# Map:         { dev = "standard_D2s_v3", staging = "standard_D4s_v3", prod = "standard_D8s_v3" }
# Environment: "dev"
# Result:      "standard_D2s_v3"

locals {
  vm_size = lookup(var.vm_sizes, var.environment, "standard_D2s_v3")
}
```

| Function | What It Does |
|----------|-------------|
| `lookup(map, key, default)` | Returns the value for `key` in the `map`. If key is not found, returns `default` |

### lookup() vs Conditional Expression

| Approach | Syntax | Best For |
|----------|--------|----------|
| `lookup()` | `lookup(map, key, default)` | Multiple options (3+ environments) |
| Conditional | `condition ? a : b` | Only 2 options (true/false) |

---

### Assignment 6: VM Size Validation

**Functions**: `length()`, `contains()`, `strcontains()`

**Why**: Invalid input can cause resource creation failures at the cloud provider level, which takes time to debug. Variable validation catches errors **before** Terraform even tries to create resources.

**When**: Always add validation to variables that have specific format requirements.

```hcl
variable "vm_size" {
  type    = string
  default = "standard_D2s_v3"

  validation {
    condition     = length(var.vm_size) >= 2 && length(var.vm_size) <= 20
    error_message = "The vm_size must be between 2 and 20 characters"
  }

  validation {
    condition     = strcontains(lower(var.vm_size), "standard")
    error_message = "The vm_size must contain the word 'standard'"
  }
}
```

| Function | What It Does | Why We Need It |
|----------|-------------|----------------|
| `length(value)` | Returns the length of a string, list, or map | Check character count |
| `contains(list, value)` | Returns true if the list contains the value | Check if a value exists in a list |
| `strcontains(string, substr)` | Returns true if the string contains the substring | Check if a string contains specific text |

---

### Assignment 7: Backup Configuration

**Functions**: `endswith()`, `sensitive()`

**Why**: Naming conventions often require specific suffixes (like `_backup`). The `endswith()` function validates this. Sensitive data like credentials must be marked with `sensitive = true` to prevent them from appearing in logs, plan output, or state file diffs.

**When**: Use `endswith()` for suffix validation. Use `sensitive` for any passwords, keys, tokens, or credentials.

```hcl
variable "backup_name" {
  type    = string
  default = "daily_backup"

  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "Backup name must end with '_backup'"
  }
}

variable "credential" {
  type      = string
  default   = "xyz123"
  sensitive = true          # Will never appear in terraform plan/apply output
}
```

| Function | What It Does |
|----------|-------------|
| `endswith(string, suffix)` | Returns true if the string ends with the suffix |
| `startswith(string, prefix)` | Returns true if the string starts with the prefix |
| `sensitive(value)` | Marks a value as sensitive (hides from output) |

---

### Assignment 9: Resource Set Management

**Functions**: `toset()`, `concat()`

**Why**: When managing resources across multiple locations, you often get **duplicate entries** from different sources. `concat()` combines the lists and `toset()` removes duplicates since sets cannot have duplicate values.

**When**: Use `concat()` to combine lists. Use `toset()` when you need unique values or when using `for_each`.

```hcl
# user_location:    ["eastus", "westus", "eastus"]    ← "eastus" is duplicated
# default_location: ["centralus"]
# After concat:     ["eastus", "westus", "eastus", "centralus"]
# After toset:      ["centralus", "eastus", "westus"]  ← duplicates removed, sorted

locals {
  unique_location = toset(concat(local.user_location, local.default_location))
}
```

| Function | What It Does |
|----------|-------------|
| `concat(list1, list2, ...)` | Combines multiple lists into one |
| `toset(list)` | Converts a list to a set (removes duplicates) |

---

### Assignment 10: Cost Calculation

**Functions**: `abs()`, `max()`

**Why**: Financial data sometimes contains negative values (refunds, credits). You need `abs()` to convert them to positive before calculations. `max()` finds the highest value in a list, useful for identifying peak costs.

**When**: Use `abs()` when dealing with financial data or any values that might be negative. Use `max()` and `min()` for finding extremes.

```hcl
# monthly_costs:  [-50, 100, 75, 200]
# positive_cost:  [50, 100, 75, 200]      ← abs() converts -50 to 50
# max_cost:       200                      ← max() finds the largest

locals {
  positive_cost = [for cost in local.monthly_costs : abs(cost)]
  max_cost      = max(local.positive_cost...)     # The ... spreads the list into arguments
}
```

| Function | What It Does |
|----------|-------------|
| `abs(number)` | Returns the absolute (positive) value of a number |
| `max(numbers...)` | Returns the largest number from the arguments |
| `min(numbers...)` | Returns the smallest number from the arguments |
| `list...` | The **splat operator** expands a list into individual arguments |

---

### Assignment 11: Timestamp Management

**Functions**: `timestamp()`, `formatdate()`

**Why**: Resources and tags often need timestamps for tracking when they were created. Different contexts need different formats: resource names need compact dates (`YYYYMMDD`), while tags need human readable dates (`DD-MM-YYYY`).

**When**: Use `timestamp()` to get the current time. Use `formatdate()` to format it for your specific use case.

```hcl
# timestamp() returns: "2026-02-09T15:30:00Z"
# formatdate for resource names: "20260209"
# formatdate for tags: "09-02-2026"

locals {
  current_time  = timestamp()
  resource_name = formatdate("YYYYMMDD", local.current_time)
  tag_date      = formatdate("DD-MM-YYYY", local.current_time)
}
```

| Function | What It Does |
|----------|-------------|
| `timestamp()` | Returns the current UTC time in RFC 3339 format |
| `formatdate(format, timestamp)` | Formats a timestamp into a custom string |

### Format Specifiers

| Specifier | Meaning | Example |
|-----------|---------|---------|
| `YYYY` | Four digit year | `2026` |
| `MM` | Two digit month | `02` |
| `DD` | Two digit day | `09` |
| `hh` | Two digit hour (24h) | `15` |
| `mm` | Two digit minute | `30` |
| `ss` | Two digit second | `00` |

---

## 🧪 Testing Functions in Terraform Console

You can test any function interactively before using it in code:

```bash
# Start the console
terraform console

# Test string functions
> lower("HELLO WORLD")
"hello world"

> replace("hello world", " ", "-")
"hello-world"

> substr("techtutorials", 0, 8)
"techtuto"

# Test numeric functions
> abs(-50)
50

> max(10, 20, 30)
30

# Test collection functions
> merge({a = "1"}, {b = "2"})
{ a = "1", b = "2" }

> concat(["a", "b"], ["c"])
["a", "b", "c"]

> toset(["a", "b", "a"])
["a", "b"]

# Test date functions
> formatdate("YYYYMMDD", timestamp())
"20260209"

# Exit console
> exit
```

---

## 🔄 Quick Reference: All Functions Used

| # | Function | Category | Input | Output | Assignment |
|---|----------|----------|-------|--------|------------|
| 1 | `lower()` | String | `"HELLO"` | `"hello"` | 1, 3 |
| 2 | `replace()` | String | `"a b", " ", "-"` | `"a-b"` | 1, 3 |
| 3 | `merge()` | Collection | `{a=1}, {b=2}` | `{a=1, b=2}` | 2 |
| 4 | `substr()` | String | `"hello", 0, 3` | `"hel"` | 3 |
| 5 | `split()` | String | `",", "a,b,c"` | `["a","b","c"]` | 4 |
| 6 | `lookup()` | Collection | `{a=1}, "a", 0` | `1` | 5 |
| 7 | `length()` | Collection | `"hello"` | `5` | 6 |
| 8 | `strcontains()` | String | `"hello", "ell"` | `true` | 6 |
| 9 | `endswith()` | String | `"test_backup", "_backup"` | `true` | 7 |
| 10 | `toset()` | Type | `["a","b","a"]` | `["a","b"]` | 9 |
| 11 | `concat()` | Collection | `["a"], ["b"]` | `["a","b"]` | 9 |
| 12 | `abs()` | Numeric | `-50` | `50` | 10 |
| 13 | `max()` | Numeric | `10, 20, 30` | `30` | 10 |
| 14 | `timestamp()` | Date | — | `"2026-02-09T..."` | 11 |
| 15 | `formatdate()` | Date | `"YYYYMMDD", ts` | `"20260209"` | 11 |

---

## 🎯 What We Did in This Project

1. **Assignment 1**: Used `lower()` and `replace()` to format project names into a consistent naming convention
2. **Assignment 2**: Used `merge()` to combine default and environment tags into a single map
3. **Assignment 3**: Used `substr()`, `lower()`, and `replace()` to format storage account names to meet Azure requirements
4. **Assignment 4**: Used `split()` and `for` expression to convert a comma separated port string into NSG rule objects
5. **Assignment 5**: Used `lookup()` to resolve VM sizes from an environment map with fallback values
6. **Assignment 6**: Used `length()` and `strcontains()` in variable validations to enforce VM size rules
7. **Assignment 7**: Used `endswith()` for name validation and `sensitive` for credential protection
8. **Assignment 9**: Used `toset()` and `concat()` to combine and deduplicate location lists
9. **Assignment 10**: Used `abs()` and `max()` to process financial cost data
10. **Assignment 11**: Used `timestamp()` and `formatdate()` to generate formatted dates for resources and tags

---

## 🔧 Commands Used

```bash
# Initialize Terraform with backend configuration
terraform init

# Open Terraform console to test functions interactively
terraform console

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
| Functions are built in | You cannot create custom functions in Terraform |
| Test in console first | Use `terraform console` to test any function before adding it to code |
| Chain functions | You can nest functions like `lower(replace(substr(...)))` |
| `merge()` last wins | If the same key exists in multiple maps, the last map's value is used |
| `toset()` removes duplicates | Sets cannot contain duplicate values |
| `sensitive = true` | Hides values from plan output and logs |
| `list...` splat operator | Expands a list into individual function arguments |
| Variable validation | Catches errors early before Terraform contacts the cloud provider |
| `lookup()` with fallback | Always provide a default value to handle missing keys |
| `formatdate()` specifiers | Use `YYYY`, `MM`, `DD`, `hh`, `mm`, `ss` for custom date formats |

---

## 📚 References

### HashiCorp Terraform Documentation
- [Terraform Built in Functions](https://developer.hashicorp.com/terraform/language/functions)
- [String Functions](https://developer.hashicorp.com/terraform/language/functions/lower)
- [Collection Functions](https://developer.hashicorp.com/terraform/language/functions/merge)
- [Numeric Functions](https://developer.hashicorp.com/terraform/language/functions/abs)
- [Date and Time Functions](https://developer.hashicorp.com/terraform/language/functions/timestamp)
- [Type Conversion Functions](https://developer.hashicorp.com/terraform/language/functions/toset)
- [Terraform Console](https://developer.hashicorp.com/terraform/cli/commands/console)
- [Variable Validation](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules)
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Microsoft Azure Documentation
- [Azure Naming Rules and Restrictions](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)
- [Azure Storage Account Naming](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview#storage-account-name)
- [Azure Network Security Groups Overview](https://learn.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview)
- [Azure Resource Tagging](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources)

### Terraform AzureRM Resource Reference
- [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
- [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
- [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group)
