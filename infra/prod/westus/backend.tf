terraform {
  backend "azurerm" {
    resource_group_name  = "databricks-demo"
    storage_account_name = "bcrterraformstatefiles"
    container_name       = "tfstate"
    key                  = "infra/prod/westus/terraform.tfstate"
  }
}