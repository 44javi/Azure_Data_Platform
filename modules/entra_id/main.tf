# /modules/entra_id/main.tf

# Get current Azure config
data "azurerm_client_config" "current" {}

# Create Data Engineers Security Group
resource "azuread_group" "data_engineers" {
  display_name     = "Data_Engineers"
  security_enabled = true
  description      = "Group for data related access"
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

