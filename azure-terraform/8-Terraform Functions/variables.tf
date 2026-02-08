# ========================================
# Assignment 1: Project Naming Convention
# ========================================
variable "project_name" {
  type        = string
  description = "Name of the project (will be formatted to lowercase with hyphens)"
  default     = "Project ALPHA Resource"
}

# ========================================
# Assignment 2: Resource Tagging
# ========================================
variable "default_tags" {
  type        = map(string)
  description = "Default company tags applied to all resources"
  default = {
    company    = "CloudOps"
    managed_by = "terraform"
  }
}

variable "environment_tags" {
  type        = map(string)
  description = "Environment specific tags"
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}

# ========================================
# Assignment 3: Storage Account Naming
# ========================================
variable "storage_account_name" {
  type        = string
  description = "Raw storage account name (will be formatted to meet Azure requirements)"
  default     = "techtutorIALS with!piyushthis should be formatted"
}

# ========================================
# Assignment 4: NSG Port Rules
# ========================================
variable "allowed_ports" {
  type        = string
  description = "Comma separated list of allowed ports"
  default     = "80,443,3306"
}

# ========================================
# Assignment 5: Environment Configuration
# ========================================
variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Enter a valid value for environment: dev, staging, or prod"
  }
}

variable "vm_sizes" {
  type        = map(string)
  description = "Map of environment names to VM sizes"
  default = {
    dev     = "standard_D2s_v3"
    staging = "standard_D4s_v3"
    prod    = "standard_D8s_v3"
  }
}

# ========================================
# Assignment 6: VM Size Validation
# ========================================
variable "vm_size" {
  type        = string
  description = "The VM size to use (must contain 'standard' and be 2 to 20 characters)"
  default     = "standard_D2s_v3"

  validation {
    condition     = length(var.vm_size) >= 2 && length(var.vm_size) <= 20
    error_message = "The vm_size must be between 2 and 20 characters"
  }

  validation {
    condition     = strcontains(lower(var.vm_size), "standard")
    error_message = "The vm_size must contain the word 'standard'"
  }
}

# ========================================
# Assignment 7: Backup Configuration
# ========================================
variable "backup_name" {
  type        = string
  description = "Backup configuration name (must end with '_backup')"
  default     = "daily_backup"

  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "Backup name must end with '_backup'"
  }
}

variable "credential" {
  type        = string
  description = "Sensitive credential for backup"
  default     = "xyz123"
  sensitive   = true
}
