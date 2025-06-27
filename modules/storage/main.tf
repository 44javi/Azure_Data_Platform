# data_resources module

# Get Azure subscription details
data "azurerm_client_config" "current" {}

# Random string for storage names
resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

# Assigned to the VMs that need access to the datalake
resource "azurerm_user_assigned_identity" "datalake" {
  name                = "id-adls-access-${var.client}-${var.suffix}"
  resource_group_name = var.resource_group_name
  location            = var.region
}

resource "azurerm_role_assignment" "datalake_blob_contributor" {
  scope                = azurerm_storage_account.adls.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.datalake.principal_id
}

# Data Lake Storage
resource "azurerm_storage_account" "adls" {
  name                            = "adls${random_string.this.result}"
  resource_group_name             = var.resource_group_name
  location                        = var.region
  min_tls_version                 = "TLS1_2"
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  is_hns_enabled                  = "true"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true #false blocks access to containers on the portal
  #shared_access_key_enabled = false

  tags = var.default_tags

  blob_properties {
    delete_retention_policy {
      days = 30
    }
  }

}

# Containers for 

resource "azurerm_storage_container" "this" {
  for_each              = toset(["bronze", "silver", "gold", "catalog"])
  name                  = each.key
  storage_account_id    = azurerm_storage_account.adls.id
  container_access_type = "private"
}


# Private Endpoint for ADLS (Azure Data Lake Storage)
resource "azurerm_private_endpoint" "adls" {
  name                = "pe-adls-${var.client}-${var.suffix}"
  location            = var.region
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  tags = var.default_tags

  private_service_connection {
    name                           = "adlsConnection"
    private_connection_resource_id = azurerm_storage_account.adls.id
    subresource_names              = ["dfs"] # For ADLS Gen2
    is_manual_connection           = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "adls" {
  name                       = "logs-adls-${var.client}-${var.suffix}"
  target_resource_id         = "${azurerm_storage_account.adls.id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_id

  dynamic "enabled_log" {
    for_each = var.adls_logs
    content {
      category = enabled_log.value
    }
  }

  metric {
    category = "Transaction"
    enabled  = true

  }
}

