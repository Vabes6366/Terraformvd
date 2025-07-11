terraform {
  required_version = ">=1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.43.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true

}


resource "azurerm_resource_group" "rg" {
  name     = "JackBicepTest"
  location = "eastus2"
}



resource "azurerm_storage_account" "storage" {
  name                     = "storagevd009"
  location                 = "eastus2"
  resource_group_name      = "JackBicepTest"
  account_tier             = "Standard"
  account_replication_type = "LRS"

}
