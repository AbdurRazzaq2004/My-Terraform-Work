# ========================================
# Assignment 1: lower() and replace()
# ========================================
# Converts "Project ALPHA Resource" → "project-alpha-resource"
locals {
  formatted_name = lower(replace(var.project_name, " ", "-"))
}

# ========================================
# Assignment 2: merge()
# ========================================
# Merges default company tags with environment tags
locals {
  merge_tags = merge(var.default_tags, var.environment_tags)
}

# ========================================
# Assignment 3: substr(), lower(), replace()
# ========================================
# Formats storage account name to meet Azure requirements:
# - Max 23 characters (substr)
# - All lowercase (lower)
# - No spaces or special characters (replace)
locals {
  storage_formatted = replace(replace(lower(substr(var.storage_account_name, 0, 23)), " ", ""), "!", "")
}

# ========================================
# Assignment 4: split() and for expression
# ========================================
# Splits "80,443,3306" into a list and creates NSG rule objects
locals {
  formatted_ports = split(",", var.allowed_ports)
  nsg_rules = [for port in local.formatted_ports : {
    name        = "port-${port}"
    port        = port
    description = "Allowed traffic on port: ${port}"
  }]
}

# ========================================
# Assignment 5: lookup()
# ========================================
# Looks up VM size from the map based on environment
# Falls back to "dev" size if environment not found
locals {
  vm_size = lookup(var.vm_sizes, var.environment, lower("dev"))
}

# ========================================
# Assignment 9: toset() and concat()
# ========================================
# Combines two location lists and removes duplicates
locals {
  user_location    = ["eastus", "westus", "eastus"]
  default_location = ["centralus"]
  unique_location  = toset(concat(local.user_location, local.default_location))
}

# ========================================
# Assignment 10: abs() and max()
# ========================================
# Converts negative costs to positive and finds maximum
locals {
  monthly_costs = [-50, 100, 75, 200]
  positive_cost = [for cost in local.monthly_costs : abs(cost)]
  max_cost      = max(local.positive_cost...)
}

# ========================================
# Assignment 11: timestamp() and formatdate()
# ========================================
# Generates formatted timestamps for different uses
locals {
  current_time  = timestamp()
  resource_name = formatdate("YYYYMMDD", local.current_time)
  tag_date      = formatdate("DD-MM-YYYY", local.current_time)
}
