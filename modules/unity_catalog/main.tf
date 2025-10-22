# /modules/unity_catalog/main.tf

terraform {
  required_providers {
    databricks = {
      source                = "databricks/databricks"
      version               = "~> 1.87.0"
      configuration_aliases = [databricks.workspace_resources]
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0"
    }
  }
}

# Unity Catalog Access Connector
resource "azurerm_databricks_access_connector" "unity" {
  name                = "uc-connector-${var.client}-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.region
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "unity_storage_account" {
  scope                = var.datalake_id
  role_definition_name = "Contributor"  
  principal_id         = azurerm_databricks_access_connector.unity.identity[0].principal_id
}

# Datalake access for Unity Catalog connector
resource "azurerm_role_assignment" "unity_storage" {
  scope                = var.datalake_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.unity.identity[0].principal_id
}

resource "azurerm_role_assignment" "unity_queue" {
  scope                = var.datalake_id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_databricks_access_connector.unity.identity[0].principal_id
}

# Resource group access for Unity Catalog connector
resource "azurerm_role_assignment" "unity_eventsubscription" {
  scope                = var.resource_group_id
  role_definition_name = "EventGrid EventSubscription Contributor"
  principal_id         = azurerm_databricks_access_connector.unity.identity[0].principal_id
}

resource "databricks_storage_credential" "unity" {
  name = "dbx_${var.client}_unity_credential"
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.unity.id
  }
}

# Catalog
resource "databricks_catalog" "main" {
  provider      = databricks.workspace_resources
  name          = "catalog_${var.client}_${var.environment}"
  comment       = "Catalog for client"
  storage_root = databricks_external_location.this["catalog"].url 
  
  properties = {
    purpose = "Development"
  }

  depends_on = [ databricks_external_location.this ]
}

resource "databricks_external_location" "this" {
  provider        = databricks.workspace_resources
  for_each        = toset(var.containers)
  name            = "${each.key}_container"
  url             = "abfss://${each.key}@${var.datalake_name}.dfs.core.windows.net/"
  credential_name = databricks_storage_credential.unity.name
  comment         = "External location for ${each.key} container"
}

# Schemas
resource "databricks_schema" "schemas" {
  provider     = databricks.workspace_resources
  for_each     = toset([for schema in var.schemas : "${schema}_schema"])
  catalog_name = databricks_catalog.main.name
  name         = each.key
  comment      = "Schema for ${each.key} data"
}
