# state.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "boardgame-rg"
    storage_account_name = "boardgame-tf-storage"
    container_name       = "tfstate"
    key                  = "terraformProjectFiles/terraform.tfstate"
  }
}
