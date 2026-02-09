# ========================================
# Resource Group (pre-existing sandbox RG)
# ========================================
resource_group_name = "1-e067cbe1-playground-sandbox"

# ========================================
# Environment  dev
# ========================================
environment = "dev"

# ========================================
# Region
# ========================================
location = "East US"

# ========================================
# Resource Name Prefix
# ========================================
prefix = "miniproject1"

# ========================================
# Network Configuration
# ========================================
vnet_address_space  = "10.0.0.0/16"
app_subnet_prefix   = "10.0.0.0/20"
mgmt_subnet_prefix  = "10.0.16.0/20"

# ========================================
# Compute Configuration
# ========================================
instance_count = 3
admin_username = "azureuser"

# ========================================
# Autoscale Configuration
# ========================================
autoscale_min           = 2
autoscale_max           = 5
scale_out_cpu_threshold = 80
scale_in_cpu_threshold  = 10
