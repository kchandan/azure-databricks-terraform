# Shared configuration for consistent naming and tagging across regions
locals {
  # Common naming convention
  naming_prefix = "databricks-${var.environment}"
  
  # Standard tags applied to all resources
  common_tags = {
    Environment   = var.environment
    Project       = "databricks-platform"
    ManagedBy     = "terraform"
    Owner         = var.owner
    CostCenter    = var.cost_center
    Region        = var.region
    CreatedDate   = formatdate("YYYY-MM-DD", timestamp())
  }
  
  # Network configuration
  network_config = {
    vnet_address_space     = ["10.0.0.0/16"]
    public_subnet_prefix   = ["10.0.1.0/24"]
    private_subnet_prefix  = ["10.0.2.0/24"]
  }
}