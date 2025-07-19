terraform {
  backend "azurerm" {} #backend settings come from .debug.prod.sh

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.2.0"
    }
    azapi ={
      source = "azure/azapi"
      version = "~> 2.3.0"
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
  subscription_id     = "5286455a-9982-4d84-8a0e-318d1f1c490c"
  features {}
}

provider "azurerm" {
  alias = "monitoring"
  features {}
  subscription_id = var.monitoring_subscription_id
}

provider "azurerm" {
  alias = "management"
  features {}
  subscription_id = var.management_subscription_id # Where Databricks workspace lives
}

provider "azapi" {
  # configuration options
  }

provider "azuread" {
  # configuration options
}


provider "databricks" {
  alias                       = "workspace_resources"
  host                        = data.azurerm_databricks_workspace.this.workspace_url
  azure_workspace_resource_id = data.azurerm_databricks_workspace.this.id
}
