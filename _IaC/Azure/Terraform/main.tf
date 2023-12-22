provider "azurerm" {
  features {}
}

# Define Terraform backend configuration
terraform {
  backend "azurerm" {                             # Use AzureRM backend for storing Terraform state
    resource_group_name = "Tanzu"                 # Azure Resource Group where Terraform state is stored
    storage_account_name = "amitdevopspipeline"   # Name of the Azure Storage Account for Terraform state
    container_name = "statefile"                  # Name of the Azure Storage Container for Terraform state
    key = "terraform.tfstate"                     # Key or path to the Terraform state file within the container
  }
}

module "RG" {
  source                = "./modules/azurerm_resource_group"
  count                 = var.create_resource_group ? 1 : 0
  resource_group_name   = var.resource_group_name
  location              = var.location
  create_resource_group = var.create_resource_group
}