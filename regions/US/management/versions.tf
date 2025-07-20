terraform {
  backend "azurerm" {} # backend settings come from .debug.prod.sh

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.1"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.70.0"
    }
  }
}

provider "azurerm" {
  storage_use_azuread = true
  #subscription_id = ""
  features {}
}

provider "azurerm" {
  alias = "monitoring"
  features {}
  subscription_id = var.monitoring_subscription_id
}

provider "azuread" {
  # configuration options
}


provider "databricks" {
  alias = "create_workspace"
}
