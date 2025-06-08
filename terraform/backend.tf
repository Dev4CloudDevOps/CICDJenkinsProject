# state.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "boardgame-rg"
    storage_account_name = "boardgame-tf-storage"  # Must be globally unique
    container_name       = "tfstate"
    key                  = "terraformProjectFiles/terraform.tfstate"
  }
}
