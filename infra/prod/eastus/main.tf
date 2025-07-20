
# Data sources
data "azurerm_client_config" "current" {}

# Random suffix for unique naming
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Local values
locals {
  environment = "prod"
  region      = var.region
  prefix      = "databricks-${local.environment}-${local.region}-${random_string.suffix.result}"
  
  common_tags = {
    Environment = local.environment
    Region      = local.region
    Project     = "databricks-platform"
    ManagedBy   = "terraform"
    Owner       = var.owner
    CostCenter  = var.cost_center
  }
}


# 👉 Use the network module
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.region
  tags     = local.common_tags
}

# Network module
module "network" {
  source              = "../../modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  prefix              = local.prefix
  tags                = local.common_tags
}

# Databricks workspace module
module "databricks_workspace" {
  source                          = "../../modules/databricks_workspace"
  workspace_name                  = "${local.prefix}-workspace"
  resource_group_name             = azurerm_resource_group.main.name
  region                          = azurerm_resource_group.main.location
  managed_resource_group_name     = "${local.prefix}-managed-rg"
  vnet_id                         = module.network.vnet_id
  public_subnet_name              = module.network.public_subnet_name
  private_subnet_name             = module.network.private_subnet_name
  public_nsg_assoc_id             = module.network.public_nsg_assoc_id
  private_nsg_assoc_id            = module.network.private_nsg_assoc_id
  databricks_sku                  = var.databricks_sku
  tags                            = local.common_tags
}



# Outputs
output "databricks_workspace_url" {
  description = "URL of the Databricks workspace"
  value       = "https://${module.databricks_workspace.workspace_url}"
}

output "databricks_workspace_id" {
  description = "ID of the Databricks workspace"
  value       = module.databricks_workspace.workspace_id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.network.vnet_id
}
