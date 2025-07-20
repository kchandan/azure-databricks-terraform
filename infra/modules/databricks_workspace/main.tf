resource "azurerm_databricks_workspace" "this" {
  name                        = var.workspace_name
  location                    = var.region
  resource_group_name         = var.resource_group_name
  managed_resource_group_name = var.managed_resource_group_name
  sku                         = var.databricks_sku

  tags = var.tags

  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = var.vnet_id
    public_subnet_name                                   = var.public_subnet_name
    private_subnet_name                                  = var.private_subnet_name
    public_subnet_network_security_group_association_id  = var.public_nsg_assoc_id
    private_subnet_network_security_group_association_id = var.private_nsg_assoc_id
  }
}
