# /modules/security/main.tf

# Get current Azure config
data "azurerm_client_config" "current" {}

# Create Data Engineers Security Group
resource "azuread_group" "data_engineers" {
  display_name     = "Data_Engineers"
  security_enabled = true
  description      = "Group for data related access"
}

# Create External Security Group
resource "azuread_group" "External_Users" {
  display_name     = "External_Users"
  security_enabled = true
  description      = "Group for guests to have access to Azure resources"
}

# Assign Databricks Workspace permissions
resource "azurerm_role_assignment" "data_engineers_workspace" {
  scope                = var.workspace_id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.data_engineers.object_id
}

# Assign Datalake permissions 
resource "azurerm_role_assignment" "data_engineers_datalake" {
  scope                = var.datalake_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_group.data_engineers.object_id
}


# Creates a Key Vault 
resource "azurerm_key_vault" "this" {
  name                       = "kv${var.client}${var.suffix}"
  resource_group_name        = var.resource_group_name
  location                   = var.region
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 30
  purge_protection_enabled   = true

  tags = var.default_tags
}

# Key vault permission
resource "azurerm_role_assignment" "data_engineers_keyvault" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_group.data_engineers.object_id
}