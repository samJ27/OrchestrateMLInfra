terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  backend "local" {
    path     = "../tfstate/dev-terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
    environment = "development"
    location = "West Europe"
    customer_name = var.customer_name
}

module {
  source = "../../modules/customer_resources"

  customer_name = local.customer_name
  environment = local.environment
  location = local.location
}