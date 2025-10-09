terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.47.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "storageaccalibe732e71d2"
    container_name       = "terraformstatee8b82039fc"
    resource_group_name  = "ali-rg-for-storage-acc"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
