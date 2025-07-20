variable "workspace_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the workspace will be created"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}

variable "managed_resource_group_name" {
  description = "Managed resource group for Databricks"
  type        = string
}

variable "vnet_id" {
  description = "Virtual network ID"
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private subnet"
  type        = string
}

variable "public_nsg_assoc_id" {
  description = "NSG association ID for the public subnet"
  type        = string
}

variable "private_nsg_assoc_id" {
  description = "NSG association ID for the private subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the workspace"
  type        = map(string)
  default     = {}
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
