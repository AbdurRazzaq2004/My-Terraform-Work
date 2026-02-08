# ========================================
# String Type
# ========================================
variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod, staging)"
  default     = "dev"
}

# ========================================
# List Type
# ========================================
variable "account_names" {
  type        = list(string)
  description = "List of Azure storage account names"
  default     = ["techtutorials11", "techtutorials12", "techtutorials13"]
}
