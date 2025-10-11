terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.47.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "storageaccali7176199951"
    container_name       = "terraformstate91d7e323f9"
    resource_group_name  = "team4-project2-sonarqube"
    key                  = "terraform.tfstate"
  }


}

provider "azurerm" {
  # Configuration options
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
