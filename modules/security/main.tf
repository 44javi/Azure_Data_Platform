# /modules/security/main.tf

# Get current Azure config
data "azurerm_client_config" "current" {}

data "azuread_group" "data_engineers" {
  display_name = "Data_Engineers"
}

# Creates a Key Vault 
resource "azurerm_key_vault" "this" {
  name                       = "kv${var.client}${var.environment}"
  resource_group_name        = var.resource_group_name
  location                   = var.region
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  soft_delete_retention_days = 30
  purge_protection_enabled = false  # Allows manual deletion

  tags = var.default_tags
}

# Key vault permission
resource "azurerm_role_assignment" "data_engineers_keyvault" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_group.data_engineers.object_id
}

resource "azurerm_role_assignment" "admin" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}