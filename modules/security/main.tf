# /modules/security/main.tf

# Get current Azure config
data "azurerm_client_config" "current" {}

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
