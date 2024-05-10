terraform {
  backend "azurerm" {
    storage_account_name = "medtechtfweu001"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    resource_group_name  = "rg-medtech-terrafrom-dev-weu"
  }
}
