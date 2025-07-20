variable "region" {
  description = "Azure region for DR deployment"
  type        = string
  default     = "westus"
}

variable "resource_group_name" {
  description = "Resource group name for DR deployment"
  type        = string
  default     = "rg-databricks-prod-westus"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "platform-team"
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "engineering"
}

variable "databricks_sku" {
  description = "Databricks workspace SKU"
  type        = string
  default     = "premium"
  validation {
    condition     = contains(["standard", "premium", "trial"], var.databricks_sku)
    error_message = "SKU must be one of: standard, premium, trial."
  }
}